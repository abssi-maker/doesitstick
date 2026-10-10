import 'package:doesitstick_server/src/generated/protocol.dart';
import 'package:doesitstick_server/src/math/concepts.dart';
import 'package:test/test.dart';

GeneratedQuestion _find(
  ConceptId concept,
  QuestionStyle style,
  List<int> operands,
) {
  for (var seed = 0; seed < 200000; seed++) {
    final q = QuestionGenerator.generateChecked(concept, style, seed);
    if (q.operands.join(',') == operands.join(',')) return q;
  }
  throw StateError('no seed produced $operands');
}

void main() {
  group('Given every concept and style', () {
    for (final concept in ConceptId.values) {
      for (final style in QuestionStyle.values) {
        test('when generating 300 questions for $concept/$style '
            'then every one passes the independent check', () {
          for (var seed = 0; seed < 300; seed++) {
            final q = QuestionGenerator.generateChecked(concept, style, seed);
            expect(QuestionChecker.check(q), isEmpty, reason: q.prompt);
            if (style == QuestionStyle.catchMistake) {
              expect(q.shownWrong, isNot(q.answerValue));
            }
          }
        });
      }
    }
  });

  group('Given the 46 × 7 example from the design review', () {
    final q = _find(ConceptId.multiply2x1, QuestionStyle.catchMistake, [46, 7]);

    test('when the shown answer is the forgotten-carry mistake '
        'then it is 282', () {
      expect(q.shownWrong, 282);
      expect(q.answerValue, 322);
    });

    test('when explaining the mistake then it names the missing 40 '
        'from 6 × 7 = 42, not the 4 in 46', () {
      expect(q.diagnosis, 40);
      expect(q.expectedAnswer, contains('40 short'));
      expect(q.expectedAnswer, contains('6 × 7 = 42'));
      expect(q.hint, contains('6 × 7'));
      expect(q.hint, isNot(contains('4 in 46')));
      expect(q.methodNote, contains('280 + 42 = 322'));
    });
  });

  group('Given a question that has been tampered with', () {
    final good = _find(ConceptId.multiply2x1, QuestionStyle.catchMistake, [
      46,
      7,
    ]);

    GeneratedQuestion copy({
      int? answer,
      int? wrong,
      int? diagnosis,
      String? expected,
    }) => GeneratedQuestion(
      concept: good.concept,
      style: good.style,
      seed: good.seed,
      operands: good.operands,
      prompt: good.prompt,
      expectedAnswer: expected ?? good.expectedAnswer,
      answerValue: answer ?? good.answerValue,
      shownWrong: wrong ?? good.shownWrong,
      diagnosis: diagnosis ?? good.diagnosis,
      methodNote: good.methodNote,
      listenFor: good.listenFor,
      hint: good.hint,
    );

    test('when the answer is off by one then the checker rejects it', () {
      expect(QuestionChecker.check(copy(answer: 323)), isNotEmpty);
    });

    test('when the diagnosis blames the 4 in 46 (280) then it is rejected', () {
      expect(QuestionChecker.check(copy(diagnosis: 280)), isNotEmpty);
    });

    test(
      'when the wrong answer is not the modeled mistake then it is rejected',
      () {
        expect(QuestionChecker.check(copy(wrong: 312)), isNotEmpty);
      },
    );

    test(
      'when the explanation drops the correct answer then it is rejected',
      () {
        expect(
          QuestionChecker.check(copy(expected: 'No, they forgot the 40.')),
          isNotEmpty,
        );
      },
    );
  });

  group('Given tonight’s three-question set', () {
    test(
      'when built then it asks solve, explain, catch with different numbers',
      () {
        for (final concept in ConceptId.values) {
          final set = QuestionGenerator.tonightSet(concept, 42);
          expect(set.map((q) => q.style), QuestionGenerator.tonightStyles);
          expect(set.map((q) => q.operands.join(',')).toSet(), hasLength(3));
        }
      },
    );

    test(
      'when avoiding seen numbers then a re-check variant uses new numbers',
      () {
        final first = QuestionGenerator.generateChecked(
          ConceptId.equivalentFractions,
          QuestionStyle.solve,
          1,
        );
        final variant = QuestionGenerator.generateChecked(
          ConceptId.equivalentFractions,
          QuestionStyle.solve,
          1,
          avoidOperands: {first.operands.join(',')},
        );
        expect(variant.operands, isNot(first.operands));
      },
    );
  });

  group('Given many tonight sets', () {
    test('when built from consecutive seeds then the questions in a set do '
        'not all share the same first operand', () {
      var allSame = 0;
      for (var seed = 0; seed < 100; seed++) {
        final set = QuestionGenerator.tonightSet(ConceptId.multiply2x1, seed);
        final tens = set.map((q) => q.operands.first ~/ 10).toSet();
        if (tens.length == 1) allSame++;
      }
      expect(allSame, lessThan(15));
    });
  });

  group('Given counting up for subtraction', () {
    test(
      'when counting from 178 to 403 then jumps land on friendly numbers',
      () {
        expect(QuestionGenerator.countUpLandmarks(178, 403), [
          180,
          200,
          400,
          403,
        ]);
      },
    );
  });
}
