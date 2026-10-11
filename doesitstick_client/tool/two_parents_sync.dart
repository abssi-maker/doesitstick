// End-to-end check of Serverpod offline sync with two parents, each with
// their own account and local SQLite database, against a running server.
//
//   dart run tool/two_parents_sync.dart [http://localhost:8080/]
//
// It creates a throwaway family, so point it at a local server.

import 'dart:async';
import 'dart:io';

import 'package:doesitstick_client/doesitstick_client.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';
import 'package:serverpod_offline_sync_client/serverpod_offline_sync_client.dart';

class _MemoryStorage implements ClientAuthSuccessStorage {
  AuthSuccess? _value;
  @override
  Future<AuthSuccess?> get() async => _value;
  @override
  Future<void> set(AuthSuccess? data) async => _value = data;
}

/// One parent: a client, an account and a local sync database.
class Parent {
  Parent(this.name, String url)
    : client = Client(url)
        ..authSessionManager = ClientAuthSessionManager(
          storage: _MemoryStorage(),
        );

  final String name;
  final Client client;
  late UuidValue user;
  late UuidValue space;
  late OfflineSyncDatabaseSession db;

  Future<void> signIn() async {
    final auth = await client.anonymousIdp.login();
    await client.auth.updateSignedInUser(auth);
    user = auth.authUserId;
  }

  Future<void> openDb(Directory dir) async {
    space = (await client.family.me())!.syncSpace!;
    db = await client.createSyncSession(
      '${dir.path}/$name.db',
      persistentUserId: user,
    );
  }

  OfflineSyncClient get _sync => OfflineSyncClient(
    ({required changes, required once}) =>
        client.familySync.sync(changes: changes, once: once),
  );

  Future<void> syncOnce() => _sync.syncOnce(db);

  OfflineSyncSubscription syncContinuously(void Function() onMerge) =>
      _sync.syncContinuously(db, onMergeSuccess: (_, _) => onMerge());

  Future<Mark> mark(Question q, Outcome outcome) async {
    final sync = db.offlineSyncDb;
    return sync.transactionForUser(
      user,
      (tx) => sync.insertRow<Mark>(
        Mark(
          questionId: q.id!,
          cardId: q.cardId,
          familyId: q.familyId,
          outcome: outcome,
          parentName: name,
          authUserId: user,
          markedAt: DateTime.now().toUtc(),
        ),
        transaction: tx,
      ),
      spaceId: space,
    );
  }

  Future<List<Mark>> localMarks(int questionId) => Mark.db.find(
    db,
    where: (t) => t.questionId.equals(questionId),
    orderBy: (t) => t.markedAt,
  );
}

var _failures = 0;

void check(bool ok, String what) {
  stdout.writeln('${ok ? 'PASS' : 'FAIL'}  $what');
  if (!ok) _failures++;
}

Future<T> timed<T>(String what, Future<T> Function() f) async {
  final sw = Stopwatch()..start();
  final r = await f();
  stdout.writeln('      $what: ${sw.elapsedMilliseconds} ms');
  return r;
}

Future<void> main(List<String> args) async {
  final url = args.isNotEmpty ? args.first : 'http://localhost:8080/';
  final dir = await Directory.systemTemp.createTemp('dis_sync_');
  final alex = Parent('Alex', url);
  final sam = Parent('Sam', url);

  await alex.signIn();
  await sam.signIn();
  final family = await alex.client.family.create('Mia', 'Alex');
  await sam.client.family.join(family.inviteCode, 'Sam');
  final ws = await alex.client.worksheet.chooseTopic(
    null,
    ConceptId.multiply2x1,
  );
  final card = await alex.client.card.card(ws.cardId!);
  final qs = card.questions.map((q) => q.question).toList();
  check(qs.length == 3, 'tonight’s card has 3 questions');

  await alex.openDb(dir);
  await sam.openDb(dir);
  check(alex.space == sam.space, 'both parents share one sync space');
  await timed('first sync (Alex)', alex.syncOnce);
  await timed('first sync (Sam)', sam.syncOnce);

  // 1. A mark made on Alex's phone reaches the server and Sam's phone.
  final m1 = await alex.mark(qs[0], Outcome.withHint);
  await timed('Alex pushes Q1', alex.syncOnce);
  final server1 = await alex.client.card.card(card.card.id!);
  check(
    server1.questions[0].marks.any((m) => m.id == m1.id),
    'the server holds Alex’s mark',
  );
  await timed('Sam pulls', sam.syncOnce);
  final samQ1 = await sam.localMarks(qs[0].id!);
  check(
    samQ1.any((m) => m.id == m1.id && m.outcome == Outcome.withHint),
    'Sam’s phone has Alex’s mark',
  );

  // 2. Offline: Alex marks the other two with no connection, syncs later;
  //    the server completes the card and schedules the re-checks.
  await alex.mark(qs[1], Outcome.gotAnswer);
  await alex.mark(qs[2], Outcome.notYet);
  check(
    (await alex.localMarks(qs[2].id!)).isNotEmpty,
    'marks are saved on the phone while offline',
  );
  await timed('Alex comes back online', alex.syncOnce);
  final home = await alex.client.family.home();
  final done = home.cards.firstWhere((c) => c.card.id == card.card.id);
  check(done.card.completedAt != null, 'the server completed the card');
  check(
    home.rechecks.where((r) => r.sourceCardId == card.card.id).length == 2,
    'day-2 and day-7 re-checks were scheduled',
  );

  // 3. Both change Q1 while apart; after syncing both phones agree.
  await sam.syncOnce();
  await alex.mark(qs[0], Outcome.gotAnswer);
  await Future<void>.delayed(const Duration(milliseconds: 20));
  await sam.mark(qs[0], Outcome.explainedWhy);
  await alex.syncOnce();
  await sam.syncOnce();
  await alex.syncOnce();
  final a = (await alex.localMarks(qs[0].id!)).last;
  final s = (await sam.localMarks(qs[0].id!)).last;
  check(
    a.id == s.id && s.outcome == Outcome.explainedWhy,
    'after edits on both phones, both show the latest (Sam’s ★)',
  );

  // 4. Live: with continuous sync, Sam sees a new mark within seconds.
  final merged = Completer<void>();
  final samLive = sam.syncContinuously(() {
    if (!merged.isCompleted) merged.complete();
  });
  final alexLive = alex.syncContinuously(() {});
  await Future<void>.delayed(const Duration(milliseconds: 500));
  final sw = Stopwatch()..start();
  final m4 = await alex.mark(qs[1], Outcome.explainedWhy);
  var arrived = false;
  while (sw.elapsed < const Duration(seconds: 10)) {
    if ((await sam.localMarks(qs[1].id!)).any((m) => m.id == m4.id)) {
      arrived = true;
      break;
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
  check(arrived, 'live: Sam’s phone got it in ${sw.elapsedMilliseconds} ms');
  await alexLive.cancel();
  await samLive.cancel();

  await alex.db.close();
  await sam.db.close();
  await dir.delete(recursive: true);
  stdout.writeln(_failures == 0 ? '\nALL PASSED' : '\n$_failures FAILED');
  exit(_failures == 0 ? 0 : 1);
}
