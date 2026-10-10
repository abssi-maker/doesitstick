import 'dart:io';

import 'package:doesitstick_server/src/generated/protocol.dart';
import 'package:doesitstick_server/src/worksheets/worksheet_reader.dart';
import 'package:test/test.dart';

/// Sends the phone-style worksheet photos in test/fixtures/worksheets to the
/// real Gemini reader. It costs API calls, so it runs only on request:
/// `RUN_E2E=1 GEMINI_API_KEY=... dart test test/e2e`. Regenerate the photos with
/// `python3 tool/make_worksheet_photos.py`.
void main() {
  final key = Platform.environment['GEMINI_API_KEY'];
  final skip = Platform.environment['RUN_E2E'] != '1'
      ? 'set RUN_E2E=1 to call Gemini'
      : (key == null || key.isEmpty)
      ? 'GEMINI_API_KEY not set'
      : null;
  final dir = Directory('test/fixtures/worksheets');

  group('Given a photo of a worksheet', () {
    for (final concept in ConceptId.values) {
      test(
        'when it practises ${concept.name} then the reader names it',
        () async {
          final photo = File('${dir.path}/${concept.name}.jpg');
          final r = await WorksheetReader.read(key!, await photo.readAsBytes());
          expect(r.concept, concept);
          expect(r.problems, isNotEmpty);
        },
        skip: skip,
        timeout: const Timeout(Duration(minutes: 2)),
      );
    }

    test(
      'when it is not math homework then no concept is named',
      () async {
        final photo = File('${dir.path}/other_reading.jpg');
        final r = await WorksheetReader.read(key!, await photo.readAsBytes());
        expect(r.concept, isNull);
      },
      skip: skip,
      timeout: const Timeout(Duration(minutes: 2)),
    );
  });
}
