import 'package:doesitstick_server/src/cards/card_service.dart';
import 'package:doesitstick_server/src/generated/sync_tables.dart';
import 'package:serverpod_offline_sync_server/serverpod_offline_sync_server.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// [withServerpod] with Serverpod offline sync running. The generated test
/// tools build a plain Serverpod that never starts the sync engine, so it's
/// started here. (Code that writes synced rows wraps the test session's
/// rollback proxy itself; see CardService.syncDatabase.)
void withSyncedServerpod(
  String testGroupName,
  TestClosure<TestEndpoints> testClosure,
) {
  withServerpod(testGroupName, (sessionBuilder, endpoints) {
    setUpAll(() async {
      final pod = sessionBuilder.build().serverpod;
      pod.initializeOfflineSync(syncTables: syncTables);
      // The engine registers its sync tables once and caches their ids, but
      // each test rolls back its writes. Register them outside any test, in
      // a real (committed) session, so the cached ids stay valid.
      final session = await pod.createSession(enableLogging: false);
      try {
        await CardService.syncDatabase(session).initialize();
      } finally {
        await session.close();
      }
    });
    testClosure(sessionBuilder, endpoints);
  });
}
