import 'package:serverpod/serverpod.dart';

import '../generated/future_calls.dart';
import '../generated/protocol.dart';
import '../rechecks/recheck_service.dart';
import '../worksheets/worksheet_service.dart';

class SweepResult {
  final int rechecks;
  final int photos;
  const SweepResult(this.rechecks, this.photos);
}

/// Safety net behind the one-off future calls: anything overdue gets done,
/// and no worksheet photo outlives its reading by more than an hour.
class MaintenanceService {
  static const sweepId = 'maintenance-sweep';
  static const interval = Duration(minutes: 15);
  static const photoMaxAge = Duration(hours: 1);
  static const recheckGrace = Duration(minutes: 5);

  /// Re-registers the recurring sweep at boot, replacing any earlier one.
  static Future<void> schedule(Serverpod pod) async {
    await pod.futureCalls.cancel(sweepId);
    await pod.futureCalls
        .callRecurring(identifier: sweepId)
        .every(interval)
        .maintenance
        .sweep();
  }

  static Future<SweepResult> sweep(Session session, {DateTime? now}) async {
    final t = (now ?? DateTime.now()).toUtc();

    final overdue = await Recheck.db.find(
      session,
      where: (r) =>
          r.status.equals(RecheckStatus.scheduled) &
          (r.dueAt < t.subtract(recheckGrace)),
    );
    var rechecks = 0;
    for (final r in overdue) {
      if (await RecheckService.materialize(session, r.id!) != null) {
        rechecks++;
      }
    }

    final stale = await Worksheet.db.find(
      session,
      where: (w) =>
          w.photoPath.notEquals(null) & (w.createdAt < t.subtract(photoMaxAge)),
    );
    var photos = 0;
    for (final ws in stale) {
      final cleaned = await WorksheetService.deletePhoto(session, ws);
      if (cleaned.photoPath != null) continue;
      final abandoned =
          ws.status == WorksheetStatus.uploaded ||
          ws.status == WorksheetStatus.reading;
      await Worksheet.db.updateRow(
        session,
        abandoned
            ? cleaned.copyWith(
                status: WorksheetStatus.needsTopic,
                note: 'That photo was never read. Pick the topic instead.',
              )
            : cleaned,
      );
      photos++;
    }
    if (rechecks + photos > 0) {
      session.log('Sweep: $rechecks re-checks, $photos photos deleted');
    }
    return SweepResult(rechecks, photos);
  }
}
