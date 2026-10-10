import 'package:serverpod/serverpod.dart';

import 'maintenance.dart';

/// Recurring every 15 minutes, registered at boot in `server.dart`.
class MaintenanceFutureCall extends FutureCall {
  Future<void> sweep(Session session) async {
    await MaintenanceService.sweep(session);
  }
}
