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
  nextStep: '40 × 7 = 280. Now: what is 6 × 7? Then add the two.',
  slips: [
    Slip(
      answer: 282,
      what: 'The 4 tens from 6 × 7 = 42 got lost.',
      ask: 'What is 6 × 7? Where did the 40 go?',
    ),
  ],
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
        questionId: 11,
        cardId: 1,
        familyId: 1,
        outcome: Outcome.gotAnswer,
        parentName: 'Sam',
        markedAt: DateTime.utc(2026, 10, 9),
      ),
    );
    final m = c.effectiveMark(qv)!;
    expect(m.by, 'Sam');
    expect(m.sync, MarkSync.shared);
  });

  Future<FamilyController> openCard(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 5000);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final c = await _offlineController();
    await tester.pumpWidget(
      MaterialApp(
        home: FamilyScope(controller: c, child: const CardScreen(cardId: 1)),
      ),
    );
    return c;
  }

  Future<void> tap(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  testWidgets('Given tonight’s card offline, when each problem is answered '
      'and explained, then all three are saved on this phone', (tester) async {
    final c = await openCard(tester);
    expect(find.text('✓ Every answer double-checked  ›'), findsOneWidget);
    expect(
      find.text('Offline (try-out) · saving on this phone'),
      findsOneWidget,
    );

    for (final id in [11, 12, 13]) {
      expect(find.text('322'), findsOneWidget);
      await tap(tester, find.byKey(const Key('gotIt')));
      if (id != 12) expect(find.text('“How do you know?”'), findsOneWidget);
      await tap(tester, find.byKey(Key('mark-$id-explainedWhy')));
      expect(find.text('Saved on this phone'), findsOneWidget);
      await tap(tester, find.byKey(const Key('nextProblem')));
    }
    expect(find.text('Done, calmly 🎉'), findsOneWidget);
    expect(c.outbox.map((m) => m.outcome).toSet(), {Outcome.explainedWhy});
    expect(c.outbox, hasLength(3));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Given a child who says 282, when the parent checks it, then '
      'the lost carry is named with a question to ask, and getting it after '
      'that is marked with a hint', (tester) async {
    final c = await openCard(tester);
    await tap(tester, find.byKey(const Key('notQuite')));
    expect(
      find.text('Take a breath. Stuck is where learning happens.'),
      findsOneWidget,
    );
    await tester.enterText(find.byKey(const Key('saidField')), '282');
    await tap(tester, find.byKey(const Key('checkSaid')));
    expect(find.text('🔎 A common slip'), findsOneWidget);
    expect(find.text('The 4 tens from 6 × 7 = 42 got lost.'), findsOneWidget);
    expect(
      find.text('Ask: “What is 6 × 7? Where did the 40 go?”'),
      findsOneWidget,
    );
    await tap(tester, find.byKey(const Key('mark-11-withHint')));
    expect(c.outbox.single.outcome, Outcome.withHint);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Given a child who says 9, then the parent is told to ask how '
      'they got it', (tester) async {
    await openCard(tester);
    await tap(tester, find.byKey(const Key('notQuite')));
    await tester.enterText(find.byKey(const Key('saidField')), '9');
    await tap(tester, find.byKey(const Key('checkSaid')));
    expect(find.text('🔎 Not one of the usual slips'), findsOneWidget);
    expect(find.text('Ask: “How did you get that? Show me.”'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Given a child who says the right answer, then the parent is '
      'asked to find out why', (tester) async {
    await openCard(tester);
    await tap(tester, find.byKey(const Key('notQuite')));
    await tester.enterText(find.byKey(const Key('saidField')), '322');
    await tap(tester, find.byKey(const Key('checkSaid')));
    expect(find.text('🎉 That’s right!'), findsOneWidget);
    await tap(tester, find.byKey(const Key('rightAskWhy')));
    expect(find.text('“How do you know?”'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Given a stuck child, when the parent goes step by step to the '
      'end, then help never skips a step and it ends kindly as not yet', (
    tester,
  ) async {
    final c = await openCard(tester);
    await tap(tester, find.byKey(const Key('notQuite')));
    await tap(tester, find.byKey(const Key('saidNothing')));
    expect(
      find.text('“Split 46 into 40 and 6. What is 40 × 7?”'),
      findsOneWidget,
    );
    await tap(tester, find.byKey(const Key('nextHint')));
    expect(
      find.text('40 × 7 = 280. Now: what is 6 × 7? Then add the two.'),
      findsOneWidget,
    );
    await tap(tester, find.byKey(const Key('nextHint')));
    expect(find.textContaining('280 + 42 = 322'), findsOneWidget);
    await tap(tester, find.byKey(const Key('nextHint')));
    expect(c.outbox.single.outcome, Outcome.notYet);
    expect(c.outbox.single.questionId, 11);
    expect(
      find.text('“Not yet is fine. We’ll try it again another day.”'),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
