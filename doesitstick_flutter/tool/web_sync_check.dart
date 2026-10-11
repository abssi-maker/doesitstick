// Checks Serverpod offline sync in a browser: the app's own OfflineMarks
// (SQLite via sqlite3.wasm + db_worker.js) against a running server.
//
//   flutter build web -t tool/web_sync_check.dart \
//     --dart-define=SERVER_URL=http://localhost:8080/ -o build/web_sync_check
//
// Serve build/web_sync_check and open it in Chrome; results go to the
// console as PASS/FAIL lines, ending with DONE.

import 'package:doesitstick_client/doesitstick_client.dart';
import 'package:doesitstick_flutter/client.dart';
import 'package:doesitstick_flutter/state/offline_marks.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

void log(String line) => debugPrint('SYNCCHECK $line');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: Text('Checking offline sync…')),
    ),
  );
  try {
    await initializeClient();
    final auth = await client.anonymousIdp.login();
    await client.auth.updateSignedInUser(auth);
    await client.family.create('Web', 'Check');
    final ws = await client.worksheet.chooseTopic(null, ConceptId.addRegroup);
    final card = await client.card.card(ws.cardId!);
    final space = (await client.family.me())!.syncSpace!;

    final marks = await OfflineMarks.open(
      user: auth.authUserId,
      space: space,
      onChange: () {},
      onSynced: () {},
    );
    log(marks != null ? 'PASS sqlite opened in the browser' : 'FAIL open');
    if (marks == null) return;
    marks.resume();
    await Future<void>.delayed(const Duration(seconds: 2));

    final q = card.questions.first.question;
    final wrote = await marks.write(q, Outcome.gotAnswer, 'Check');
    log(wrote ? 'PASS mark saved in the browser' : 'FAIL write');

    final sw = Stopwatch()..start();
    var onServer = false;
    while (sw.elapsed < const Duration(seconds: 15)) {
      final now = await client.card.card(card.card.id!);
      if (now.questions.first.marks.isNotEmpty) {
        onServer = true;
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }
    log(
      onServer
          ? 'PASS server got it in ${sw.elapsedMilliseconds} ms'
          : 'FAIL server never got the mark',
    );
    await marks.close();
  } catch (e, st) {
    log('FAIL $e\n$st');
  } finally {
    log('DONE');
  }
}
