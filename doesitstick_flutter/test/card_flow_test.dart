import 'package:doesitstick_client/doesitstick_client.dart';
import 'package:doesitstick_flutter/screens/card_screen.dart';
import 'package:doesitstick_flutter/screens/home_shell.dart';
import 'package:doesitstick_flutter/state/family_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Question _q(int id, int pos, QuestionStyle style) => Question(
  id: id,
  cardId: 1,
  familyId: 1,
  position: pos,
  conceptId: ConceptId.multiply2x1,
  style: style,
  seed: 1,
  operands: [46, 7],
  prompt: 'What is 46 × 7?',
  expectedAnswer: '322',
  answerValue: 322,
  methodNote: 'Box method: 40 × 7 = 280 and 6 × 7 = 42. 280 + 42 = 322.',
  listenFor: 'Splits 46 into 40 and 6.',
  hint: 'Split 46 into 40 and 6. What is 40 × 7?',
  checkedByCode: true,
);

HomeState _home() => HomeState(
  family: FamilyView(
    familyId: 1,
    childName: 'Maya',
    inviteCode: 'ABC234',
    me: 'Alex',
    parents: ['Alex', 'Sam'],
  ),
  worksheets: [],
  rechecks: [],
  aiReaderEnabled: false,
  cards: [
    CardView(
      card: QuestionCard(
        id: 1,
        familyId: 1,
        conceptId: ConceptId.multiply2x1,
        kind: CardKind.tonight,
        recheckDay: 0,
      ),
      conceptTitle: '2-digit × 1-digit multiplication',
      methodName: 'Box (area) method',
      methodLine: 'Split the big number into tens and ones.',
      grade: 4,
      questions: [
        QuestionView(question: _q(11, 0, QuestionStyle.solve), marks: []),
        QuestionView(question: _q(12, 1, QuestionStyle.explain), marks: []),
        QuestionView(
          question: _q(13, 2, QuestionStyle.catchMistake),
          marks: [],
        ),
      ],
    ),
  ],
);

Future<FamilyController> _offlineController() async {
  final prefs = await SharedPreferences.getInstance();
  final c = FamilyController(prefs: prefs)
    ..home = _home()
    ..setDemoOffline(true);
  return c;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Given an offline phone, when a mark is made, then it is queued and '
      'survives an app restart', () async {
    final c = await _offlineController();
    final qv = c.home!.cards.first.questions.first;
    await c.mark(qv.question, Outcome.explainedWhy);

    expect(c.outbox, hasLength(1));
    final m = c.effectiveMark(qv)!;
    expect(m.outcome, Outcome.explainedWhy);
    expect(m.sync, MarkSync.savedOnPhone);

    final prefs = await SharedPreferences.getInstance();
    final restarted = FamilyController(prefs: prefs);
    await restarted
        .start()
        .timeout(
          const Duration(milliseconds: 50),
          onTimeout: () {},
        )
        .catchError((_) {});
    expect(restarted.outbox.single.questionId, 11);
  });

  test('Given a queued mark, when the parent changes their mind, then only '
      'the latest unsent mark is kept', () async {
    final c = await _offlineController();
    final q = c.home!.cards.first.questions.first.question;
    await c.mark(q, Outcome.notYet);
    await c.mark(q, Outcome.withHint);
    expect(c.outbox.single.outcome, Outcome.withHint);
  });

  test('Given a mark from the other parent, then it shows as theirs', () async {
    final c = await _offlineController();
    final qv = QuestionView(
      question: _q(11, 0, QuestionStyle.solve),
      marks: [],
      latest: Mark(
        id: 1,
        questionId: 11,
        cardId: 1,
        familyId: 1,
        outcome: Outcome.gotAnswer,
        parentName: 'Sam',
        clientMarkId: 'x',
        markedAt: DateTime.utc(2026, 10, 9),
      ),
    );
    final m = c.effectiveMark(qv)!;
    expect(m.by, 'Sam');
    expect(m.sync, MarkSync.shared);
  });

  testWidgets('Given tonight’s card, when all three are marked offline, then '
      'answers stay visible and each says it is saved on this phone', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 7000);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final c = await _offlineController();

    await tester.pumpWidget(
      MaterialApp(
        home: FamilyScope(controller: c, child: const CardScreen(cardId: 1)),
      ),
    );
    expect(find.text('322'), findsNWidgets(3));
    expect(find.text('✓ Answer checked by code'), findsNWidgets(3));
    expect(find.text('Offline (demo)'), findsOneWidget);

    for (final id in [11, 12, 13]) {
      final button = find.byKey(Key('mark-$id-explainedWhy'));
      await tester.ensureVisible(button);
      await tester.pump();
      await tester.tap(button);
      await tester.pump();
    }
    expect(find.text('Saved on this phone'), findsNWidgets(3));
    expect(find.text('Done, together 🎉'), findsOneWidget);
    expect(c.outbox, hasLength(3));

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Given a stuck child, when the parent climbs the hint ladder '
      'to the kind ending, then the question is marked not yet', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 7000);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final c = await _offlineController();
    await tester.pumpWidget(
      MaterialApp(
        home: FamilyScope(controller: c, child: const CardScreen(cardId: 1)),
      ),
    );
    final next = find.byKey(const Key('nextHint')).first;
    await tester.tap(next);
    await tester.pump();
    expect(find.textContaining('Split 46 into 40 and 6'), findsWidgets);
    expect(
      find.text('If they get it now, mark “With a hint”.'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('nextHint')).first);
    await tester.pump();
    await tester.tap(find.byKey(const Key('nextHint')).first);
    await tester.pump();
    expect(
      find.text('“Great one to ask your teacher about tomorrow!”'),
      findsOneWidget,
    );
    expect(c.outbox.single.outcome, Outcome.notYet);
    expect(c.outbox.single.questionId, 11);
    await tester.pumpWidget(const SizedBox());
  });
}
