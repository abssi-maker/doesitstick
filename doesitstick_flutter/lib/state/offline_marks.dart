import 'dart:async';

import 'package:doesitstick_client/doesitstick_client.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:serverpod_offline_sync_client/serverpod_offline_sync_client.dart';

import '../client.dart';

/// The family's marks with Serverpod offline sync. Each phone keeps a local
/// SQLite copy, writes marks into the family's space (offline too), and syncs
/// continuously with the server, which completes cards, schedules re-checks
/// and passes the marks to the other parent's phone.
class OfflineMarks {
  OfflineMarks._(
    this._db,
    this._user,
    this._space,
    this._onChange,
    this._onSynced,
  );

  final OfflineSyncDatabaseSession _db;
  final UuidValue _user;
  final UuidValue _space;
  final VoidCallback _onChange;

  /// Called after a sync round merged changes, so the caller can refetch
  /// what the server made of them (completed cards, re-checks).
  final VoidCallback _onSynced;
  OfflineSyncSubscription? _sync;
  Timer? _retry;
  bool _closed = false;

  /// Marks in the family space, by question id, oldest first.
  Map<int, List<Mark>> byQuestion = const {};

  /// True while a sync session with the server is running.
  bool connected = false;

  /// Opens the local database. Null when this device can't run it (for
  /// example a browser without the SQLite worker); the caller then sends
  /// marks straight to the server.
  static Future<OfflineMarks?> open({
    required UuidValue user,
    required UuidValue space,
    required VoidCallback onChange,
    required VoidCallback onSynced,
  }) async {
    try {
      const name = 'did_it_stick_marks.db';
      final path = kIsWeb
          ? name
          : '${(await getApplicationSupportDirectory()).path}/$name';
      final db = await client.createSyncSession(
        path,
        persistentUserId: user,
        isDebugMode: kDebugMode,
      );
      final marks = OfflineMarks._(db, user, space, onChange, onSynced);
      await marks._reload();
      return marks;
    } catch (e) {
      debugPrint('Offline sync unavailable here: $e');
      return null;
    }
  }

  /// Syncs through the family endpoint, whose server hook reacts to marks.
  OfflineSyncClient get _client => OfflineSyncClient(
    ({required changes, required once}) =>
        client.familySync.sync(changes: changes, once: once),
  );

  /// Keeps syncing until [pause]; reconnects on its own after a drop.
  void resume() {
    if (_sync != null || _closed) return;
    _retry?.cancel();
    final sub = _client.syncContinuously(
      _db,
      onMergeSuccess: (_, _) async {
        await _reload();
        _onSynced();
      },
    );
    _sync = sub;
    connected = true;
    _onChange();
    sub.done.then(
      (_) => _ended(sub),
      onError: (Object e) {
        debugPrint('Sync stopped: $e');
        _ended(sub);
      },
    );
  }

  void _ended(OfflineSyncSubscription sub) {
    if (_sync != sub) return; // paused on purpose
    _sync = null;
    connected = false;
    _onChange();
    if (!_closed) _retry = Timer(const Duration(seconds: 3), resume);
  }

  /// Stops syncing (the "try offline mode" switch); marks still save here.
  Future<void> pause() async {
    _retry?.cancel();
    final sub = _sync;
    _sync = null;
    connected = false;
    _onChange();
    await sub?.cancel();
  }

  /// Saves the mark in the family space on this phone; it reaches the server
  /// and the partner on the next sync. False when this phone can't act in
  /// the space yet (it has never synced), so the caller sends it directly.
  Future<bool> write(Question q, Outcome outcome, String parentName) async {
    try {
      final db = _db.offlineSyncDb;
      await db.transactionForUser(
        _user,
        (tx) => db.insertRow<Mark>(
          Mark(
            questionId: q.id!,
            cardId: q.cardId,
            familyId: q.familyId,
            outcome: outcome,
            parentName: parentName,
            authUserId: _user,
            markedAt: DateTime.now().toUtc(),
          ),
          transaction: tx,
        ),
        spaceId: _space,
      );
      await _reload();
      return true;
    } catch (e) {
      debugPrint('Could not save the mark offline: $e');
      return false;
    }
  }

  Future<void> _reload() async {
    final marks = await Mark.db.find(_db, orderBy: (t) => t.markedAt);
    final map = <int, List<Mark>>{};
    for (final m in marks) {
      (map[m.questionId] ??= []).add(m);
    }
    byQuestion = map;
    _onChange();
  }

  Future<void> close() async {
    _closed = true;
    await pause();
    await _db.close();
  }
}
