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
/// worksheet photos are deleted after the re-check week, and a photo that was
/// never read is handed back to the parent to pick the topic.
class MaintenanceService {
  static const sweepId = 'maintenance-sweep';
  static const interval = Duration(minutes: 15);
  static const photoMaxAge = Duration(days: WorksheetService.photoKeepDays);
  static const unreadAfter = Duration(hours: 1);
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

    // A photo that never got read (the reader was down, the app closed
    // mid-upload): let the parent pick the topic instead of waiting.
    final unread = await Worksheet.db.find(
      session,
      where: (w) =>
          (w.status.equals(WorksheetStatus.uploaded) |
              w.status.equals(WorksheetStatus.reading)) &
          (w.createdAt < t.subtract(unreadAfter)),
    );
    for (final ws in unread) {
      await Worksheet.db.updateRow(
        session,
        ws.copyWith(
          status: WorksheetStatus.needsTopic,
          note: 'That photo was never read. Pick the topic instead.',
        ),
      );
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
      await Worksheet.db.updateRow(session, cleaned);
      photos++;
    }
    if (rechecks + photos > 0) {
      session.log('Sweep: $rechecks re-checks, $photos photos deleted');
    }
    return SweepResult(rechecks, photos);
  }
}
