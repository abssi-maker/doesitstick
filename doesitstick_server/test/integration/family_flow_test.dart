import 'dart:async';
import 'dart:typed_data';

import 'package:doesitstick_server/src/generated/protocol.dart';
import 'package:doesitstick_server/src/maintenance/maintenance.dart';
import 'package:doesitstick_server/src/rechecks/recheck_service.dart';
import 'package:doesitstick_server/src/worksheets/worksheet_reader.dart';
import 'package:doesitstick_server/src/worksheets/worksheet_service.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _alexId = '11111111-1111-4111-8111-111111111111';
const _samId = '22222222-2222-4222-8222-222222222222';
const _otherId = '33333333-3333-4333-8333-333333333333';

int _seq = 0;
MarkInput _mark(int questionId, Outcome outcome, {String? id, DateTime? at}) =>
    MarkInput(
      clientMarkId: id ?? 'm-${_seq++}',
      questionId: questionId,
      outcome: outcome,
      markedAt: at ?? DateTime.now().toUtc(),
    );

void main() {
  withServerpod('Given two parents in one family', (sessionBuilder, endpoints) {
    final alex = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(_alexId, {}),
    );
    final sam = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(_samId, {}),
    );
    final other = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(_otherId, {}),
    );

    late FamilyView family;
    setUp(() async {
      family = await endpoints.family.create(alex, 'Maya', 'Alex');
      await endpoints.family.join(sam, family.inviteCode, 'Sam');
    });

    Future<CardView> tonight(ConceptId concept) async {
      final ws = await endpoints.worksheet.chooseTopic(alex, null, concept);
      return endpoints.card.card(alex, ws.cardId!);
    }

    test('when both have joined then both see the same family', () async {
      final a = await endpoints.family.me(alex);
      final s = await endpoints.family.me(sam);
      expect(a!.familyId, s!.familyId);
      expect(s.parents, ['Alex', 'Sam']);
      expect(s.me, 'Sam');
    });

    test(
      'when a third adult uses the code then they are turned away',
      () async {
        await expectLater(
          endpoints.family.join(other, family.inviteCode, 'Pat'),
          throwsA(isA<DidItStickException>()),
        );
      },
    );

    test(
      'when create is retried after a lost reply then the same family returns',
      () async {
        final again = await endpoints.family.create(alex, 'Maya', 'Alex');
        expect(again.familyId, family.familyId);
        expect(again.parents, ['Alex', 'Sam']);
      },
    );

    test(
      'when join is retried with the same code then the same family returns',
      () async {
        final again = await endpoints.family.join(
          sam,
          family.inviteCode,
          'Sam',
        );
        expect(again.familyId, family.familyId);
        expect(again.parents, ['Alex', 'Sam']);
      },
    );

    test(
      'when a parent tries to join another family then they are turned away',
      () async {
        final leo = await endpoints.family.create(other, 'Leo', 'Pat');
        await expectLater(
          endpoints.family.join(sam, leo.inviteCode, 'Sam'),
          throwsA(isA<DidItStickException>()),
        );
      },
    );

    test('when a topic is picked then both phones get 3 code-checked '
        'questions with answers and a method note', () async {
      final card = await tonight(ConceptId.multiply2x1);
      final home = await endpoints.family.home(sam);
      expect(home.cards.single.card.id, card.card.id);
      expect(card.questions, hasLength(3));
      expect(card.methodLine, isNotEmpty);
      for (final q in card.questions) {
        expect(q.question.checkedByCode, isTrue);
        expect(q.question.expectedAnswer, isNotEmpty);
      }
    });

    test(
      'when an offline queue is sent twice then each mark is stored once',
      () async {
        final card = await tonight(ConceptId.addRegroup);
        final q = card.questions.first.question;
        final queue = [_mark(q.id!, Outcome.gotAnswer, id: 'offline-1')];
        expect(await endpoints.card.syncMarks(sam, queue), ['offline-1']);
        expect(await endpoints.card.syncMarks(sam, queue), ['offline-1']);
        final after = await endpoints.card.card(alex, card.card.id!);
        expect(after.questions.first.marks, hasLength(1));
        expect(after.questions.first.latest!.parentName, 'Sam');
      },
    );

    test(
      'when both parents mark the same question then the later mark wins',
      () async {
        final card = await tonight(ConceptId.addRegroup);
        final q = card.questions.first.question;
        final t = DateTime.now().toUtc().subtract(const Duration(minutes: 5));
        // Sam's offline mark arrives last but was made first.
        await endpoints.card.syncMarks(alex, [
          _mark(
            q.id!,
            Outcome.explainedWhy,
            at: t.add(const Duration(minutes: 1)),
          ),
        ]);
        await endpoints.card.syncMarks(sam, [
          _mark(q.id!, Outcome.withHint, at: t),
        ]);
        final after = await endpoints.card.card(sam, card.card.id!);
        expect(after.questions.first.latest!.outcome, Outcome.explainedWhy);
        expect(after.questions.first.marks, hasLength(2));
      },
    );

    test('when another family marks our question then it is ignored', () async {
      final card = await tonight(ConceptId.addRegroup);
      await endpoints.family.create(other, 'Leo', 'Pat');
      final accepted = await endpoints.card.syncMarks(other, [
        _mark(card.questions.first.question.id!, Outcome.notYet),
      ]);
      expect(accepted, isEmpty);
      await expectLater(
        endpoints.card.card(other, card.card.id!),
        throwsA(isA<DidItStickException>()),
      );
    });

    test(
      'when Alex marks a question then Sam’s stream gets the update live',
      () async {
        final card = await tonight(ConceptId.multiply2x2);
        final stream = endpoints.family.updates(sam);
        final received = <FamilyEvent>[];
        final connected = Completer<void>();
        final sub = stream.listen((e) {
          received.add(e);
          if (!connected.isCompleted) connected.complete();
        });
        await connected.future;
        await endpoints.card.syncMarks(alex, [
          _mark(card.questions.first.question.id!, Outcome.explainedWhy),
        ]);
        await flushEventQueue();
        await sub.cancel();
        expect(received.map((e) => e.kind), containsAll(['hello', 'mark']));
        expect(
          received.firstWhere((e) => e.kind == 'mark').message,
          'Alex: Q1 explained why',
        );
      },
    );

    test('when tonight’s card has a shaky answer then day-2 and day-7 '
        're-checks are scheduled once', () async {
      final card = await tonight(ConceptId.subtractCountUp);
      final qs = card.questions.map((q) => q.question).toList();
      await endpoints.card.syncMarks(alex, [
        _mark(qs[0].id!, Outcome.explainedWhy),
        _mark(qs[1].id!, Outcome.withHint),
        _mark(qs[2].id!, Outcome.gotAnswer),
      ]);
      // A late duplicate must not schedule again.
      await endpoints.card.syncMarks(sam, [_mark(qs[2].id!, Outcome.notYet)]);
      final home = await endpoints.family.home(alex);
      expect(home.rechecks.map((r) => r.dayOffset), [2, 7]);
      expect(
        home.rechecks.every((r) => r.status == RecheckStatus.scheduled),
        isTrue,
      );
    });

    test(
      'when every answer was explained then only the day-7 check is set',
      () async {
        final card = await tonight(ConceptId.equivalentFractions);
        await endpoints.card.syncMarks(alex, [
          for (final q in card.questions)
            _mark(q.question.id!, Outcome.explainedWhy),
        ]);
        final home = await endpoints.family.home(alex);
        expect(home.rechecks.map((r) => r.dayOffset), [7]);
      },
    );

    test(
      'when jumping ahead 2 days then the re-check asks only the shaky '
      'questions, with new numbers, and the digest shows the result',
      () async {
        final card = await tonight(ConceptId.multiply2x1);
        final qs = card.questions.map((q) => q.question).toList();
        await endpoints.card.syncMarks(alex, [
          _mark(qs[0].id!, Outcome.explainedWhy),
          _mark(qs[1].id!, Outcome.withHint),
          _mark(qs[2].id!, Outcome.notYet),
        ]);
        var digest = await endpoints.progress.digest(sam);
        expect(digest.concepts.single.status, 'growing');

        expect(await endpoints.progress.jumpAhead(sam, 2), 1);
        expect(await endpoints.progress.jumpAhead(sam, 2), 0);

        final home = await endpoints.family.home(sam);
        final recheck = home.cards.firstWhere(
          (c) => c.card.kind == CardKind.recheck,
        );
        expect(recheck.card.recheckDay, 2);
        expect(recheck.questions.map((q) => q.question.style), [
          QuestionStyle.explain,
          QuestionStyle.catchMistake,
        ]);
        final oldNumbers = qs.map((q) => q.operands.join(',')).toSet();
        for (final q in recheck.questions) {
          expect(oldNumbers, isNot(contains(q.question.operands.join(','))));
          expect(q.question.checkedByCode, isTrue);
        }
        expect(
          home.rechecks.firstWhere((r) => r.dayOffset == 2).fastForwarded,
          isTrue,
        );

        await endpoints.card.syncMarks(sam, [
          for (final q in recheck.questions)
            _mark(q.question.id!, Outcome.gotAnswer),
        ]);
        digest = await endpoints.progress.digest(alex);
        expect(digest.concepts.single.status, 'stuck');
        expect(digest.stuckCount, 1);
      },
    );

    test('when a re-check fires twice then only one card is made', () async {
      final card = await tonight(ConceptId.divideByOneDigit);
      await endpoints.card.syncMarks(alex, [
        for (final q in card.questions) _mark(q.question.id!, Outcome.notYet),
      ]);
      final session = sessionBuilder.build();
      final r = (await Recheck.db.find(session)).first;
      expect(await RecheckService.materialize(session, r.id!), isNotNull);
      expect(await RecheckService.materialize(session, r.id!), isNull);
    });

    test(
      'when sharing the digest then a link appears and can be revoked',
      () async {
        final link = await endpoints.progress.shareDigest(alex);
        expect(link.url, contains('/s/'));
        expect((await endpoints.family.me(sam))!.shareUrl, link.url);
        await endpoints.progress.stopSharing(sam);
        expect((await endpoints.family.me(alex))!.shareUrl, isNull);
      },
    );
  });

  withServerpod('Given a photographed worksheet', (sessionBuilder, endpoints) {
    final alex = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(_alexId, {}),
    );

    tearDown(() => WorksheetService.readOverride = null);

    Future<Worksheet> uploaded() async {
      await endpoints.family.create(alex, 'Maya', 'Alex');
      final ticket = await endpoints.worksheet.startPhoto(alex);
      final session = sessionBuilder.build();
      final ws = (await Worksheet.db.findById(session, ticket.worksheetId))!;
      await session.storage.storeFile(
        storageId: WorksheetService.storageId,
        path: ws.photoPath!,
        byteData: ByteData.sublistView(
          Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xE0, 1, 2, 3]),
        ),
      );
      return Worksheet.db.updateRow(
        session,
        ws.copyWith(status: WorksheetStatus.reading),
      );
    }

    test('when the reader recognises the topic then a card is made and the '
        'photo is kept for the family', () async {
      WorksheetService.readOverride = (_) async => WorksheetReading(
        concept: ConceptId.multiply2x1,
        confidence: 'high',
        problems: ['46 × 7', '38 × 5'],
        note: 'Box-method multiplication.',
      );
      final ws = await uploaded();
      final session = sessionBuilder.build();
      await WorksheetService.process(session, ws.id!);
      final after = (await Worksheet.db.findById(session, ws.id!))!;
      expect(after.status, WorksheetStatus.ready);
      expect(after.cardId, isNotNull);
      expect(after.detectedProblems, ['46 × 7', '38 × 5']);
      expect(after.photoDeletedAt, isNull);
      // Tonight's questions coach the worksheet's own problems first.
      final card = await endpoints.card.card(alex, after.cardId!);
      final qs = card.questions.map((q) => q.question).toList();
      expect(qs[0].operands, [46, 7]);
      expect(qs[1].operands, [38, 5]);
      expect([for (final q in qs) q.fromWorksheet], [true, true, false]);
      expect(qs.every((q) => q.checkedByCode), isTrue);
      expect(await endpoints.worksheet.photo(alex, ws.id!), isNotNull);
    });

    test(
      'when another family asks for the photo then they get nothing',
      () async {
        final ws = await uploaded();
        final other = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            _otherId,
            {},
          ),
        );
        await endpoints.family.create(other, 'Leo', 'Pat');
        expect(await endpoints.worksheet.photo(other, ws.id!), isNull);
      },
    );

    test(
      'when a parent deletes the photo then it is gone right away',
      () async {
        final ws = await uploaded();
        final after = await endpoints.worksheet.deletePhoto(alex, ws.id!);
        expect(after.photoDeletedAt, isNotNull);
        expect(await endpoints.worksheet.photo(alex, ws.id!), isNull);
        expect(
          await sessionBuilder.build().storage.fileExists(
            storageId: WorksheetService.storageId,
            path: ws.photoPath!,
          ),
          isFalse,
        );
      },
    );

    test('when the reader fails then the parent is asked for the topic and '
        'can still see the photo', () async {
      WorksheetService.readOverride = (_) async => throw Exception('boom');
      final ws = await uploaded();
      final session = sessionBuilder.build();
      await WorksheetService.process(session, ws.id!);
      final after = (await Worksheet.db.findById(session, ws.id!))!;
      expect(after.status, WorksheetStatus.needsTopic);
      expect(after.photoDeletedAt, isNull);

      final fixed = await endpoints.worksheet.chooseTopic(
        alex,
        ws.id!,
        ConceptId.addRegroup,
      );
      expect(fixed.status, WorksheetStatus.ready);
      expect(fixed.cardId, isNotNull);
    });
  });

  withServerpod('Given the maintenance sweep', (sessionBuilder, endpoints) {
    final alex = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(_alexId, {}),
    );

    test('when a re-check is overdue and its call was missed then the sweep '
        'makes the card, once', () async {
      await endpoints.family.create(alex, 'Maya', 'Alex');
      final ws = await endpoints.worksheet.chooseTopic(
        alex,
        null,
        ConceptId.addRegroup,
      );
      final card = await endpoints.card.card(alex, ws.cardId!);
      await endpoints.card.syncMarks(alex, [
        for (final q in card.questions) _mark(q.question.id!, Outcome.notYet),
      ]);
      final session = sessionBuilder.build();
      final later = DateTime.now().toUtc().add(const Duration(days: 3));
      final first = await MaintenanceService.sweep(session, now: later);
      expect(first.rechecks, 1); // day 2 is due, day 7 is not
      final again = await MaintenanceService.sweep(session, now: later);
      expect(again.rechecks, 0);
    });

    test('when a photo was never read then the parent is asked for the topic, '
        'and the photo is deleted after the re-check week', () async {
      await endpoints.family.create(alex, 'Maya', 'Alex');
      final ticket = await endpoints.worksheet.startPhoto(alex);
      final session = sessionBuilder.build();
      final ws = (await Worksheet.db.findById(session, ticket.worksheetId))!;
      await session.storage.storeFile(
        storageId: WorksheetService.storageId,
        path: ws.photoPath!,
        byteData: ByteData.sublistView(Uint8List.fromList([0xFF, 0xD8, 1])),
      );
      final soon = await MaintenanceService.sweep(
        session,
        now: DateTime.now().toUtc().add(const Duration(hours: 2)),
      );
      expect(soon.photos, 0);
      final unread = (await Worksheet.db.findById(session, ws.id!))!;
      expect(unread.status, WorksheetStatus.needsTopic);
      expect(unread.photoPath, isNotNull);

      final weekLater = await MaintenanceService.sweep(
        session,
        now: DateTime.now().toUtc().add(const Duration(days: 8)),
      );
      expect(weekLater.photos, 1);
      final after = (await Worksheet.db.findById(session, ws.id!))!;
      expect(after.photoPath, isNull);
      expect(after.photoDeletedAt, isNotNull);
      expect(
        await session.storage.fileExists(
          storageId: WorksheetService.storageId,
          path: ws.photoPath!,
        ),
        isFalse,
      );
    });
  });

  withServerpod('Given a signed-out visitor', (sessionBuilder, endpoints) {
    test('when asking for family data then access is refused', () async {
      final anon = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.unauthenticated(),
      );
      await expectLater(
        endpoints.family.home(anon),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });
  });

  group('Given a Gemini reply', () {
    test('when it names a supported concept then it is parsed', () {
      final r = WorksheetReader.parse({
        'candidates': [
          {
            'finishReason': 'STOP',
            'content': {
              'role': 'model',
              'parts': [
                {
                  'text':
                      '{"concept":"multiply2x1","confidence":"high",'
                      '"problems":["46 × 7"],"note":"Multiplying."}',
                },
              ],
            },
          },
        ],
      });
      expect(r.concept, ConceptId.multiply2x1);
      expect(r.problems, ['46 × 7']);
    });

    test('when the photo is blocked then no concept is returned', () {
      final r = WorksheetReader.parse({
        'promptFeedback': {'blockReason': 'SAFETY'},
      });
      expect(r.concept, isNull);
    });

    test('when it stops for safety then no concept is returned', () {
      final r = WorksheetReader.parse({
        'candidates': [
          {'finishReason': 'IMAGE_SAFETY'},
        ],
      });
      expect(r.concept, isNull);
    });
  });
}
