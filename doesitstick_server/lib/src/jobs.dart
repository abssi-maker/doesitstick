import 'dart:async';

import 'package:serverpod/serverpod.dart';

/// Background work. Future calls do it when the server has them; on a
/// Serverpod Cloud plan that turns future calls off, the same work runs in
/// this process instead, so the app behaves the same either way.
class Jobs {
  static bool futureCallsOn(Serverpod pod) =>
      pod.config.database != null && pod.config.futureCall.enabled;

  /// Runs [work] after the current request returns, in its own session.
  static void runSoon(
    Serverpod pod,
    String name,
    Future<void> Function(Session session) work,
  ) {
    unawaited(() async {
      final session = await pod.createSession(enableLogging: true);
      try {
        await work(session);
      } catch (e, stackTrace) {
        session.log(
          '$name failed: $e',
          level: LogLevel.error,
          exception: e,
          stackTrace: stackTrace,
        );
      } finally {
        await session.close();
      }
    }());
  }
}
