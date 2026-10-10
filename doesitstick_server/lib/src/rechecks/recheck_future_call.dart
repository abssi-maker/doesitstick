import 'package:serverpod/serverpod.dart';

import 'recheck_service.dart';

/// Fires when a re-check is due (day 2 or day 7).
class RecheckFutureCall extends FutureCall {
  Future<void> materialize(Session session, int recheckId) async {
    await RecheckService.materialize(session, recheckId);
  }
}
