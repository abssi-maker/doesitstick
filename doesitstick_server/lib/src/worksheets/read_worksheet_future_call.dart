import 'package:serverpod/serverpod.dart';

import 'worksheet_service.dart';

/// Background job: reads a freshly uploaded worksheet photo.
class ReadWorksheetFutureCall extends FutureCall {
  Future<void> read(Session session, int worksheetId) async {
    await WorksheetService.process(session, worksheetId);
  }
}
