import 'dart:math';

import '../generated/protocol.dart';

/// What the parent sees about a concept: a name, a grade, and a one-line note
/// on the classroom method, so they don't need to know the method themselves.
class ConceptInfo {
  final ConceptId id;
  final String title;
  final int grade;
  final String methodName;
  final String methodLine;
  final String example;

  const ConceptInfo(
    this.id,
    this.title,
    this.grade,
    this.methodName,
    this.methodLine,
    this.example,
  );
}

const conceptInfos = <ConceptId, ConceptInfo>{
  ConceptId.addRegroup: ConceptInfo(
    ConceptId.addRegroup,
    '3-digit addition with regrouping',
    3,
    'Partial sums',
    'Add hundreds, tens and ones separately, then combine the three parts.',
    '278 + 146',
  ),
  ConceptId.subtractCountUp: ConceptInfo(
    ConceptId.subtractCountUp,
    '3-digit subtraction',
    3,
    'Counting up (open number line)',
    'Start at the smaller number and jump to friendly tens and hundreds '
        'until you reach the bigger one. The jumps add up to the answer.',
    '403 − 178',
  ),
  ConceptId.multiply2x1: ConceptInfo(
    ConceptId.multiply2x1,
    '2-digit × 1-digit multiplication',
    4,
    'Box (area) method',
    'Split the big number into tens and ones, multiply each part, '
        'then add the parts.',
    '46 × 7',
  ),
  ConceptId.multiply2x2: ConceptInfo(
    ConceptId.multiply2x2,
    '2-digit × 2-digit multiplication',
    5,
    'Area model (4 boxes)',
    'Split both numbers into tens and ones, fill four boxes, add all four.',
    '23 × 45',
  ),
  ConceptId.divideByOneDigit: ConceptInfo(
    ConceptId.divideByOneDigit,
    'Dividing by a 1-digit number',
    4,
    'Partial quotients',
    'Take away big friendly chunks (like 10 groups) first, '
        'then smaller ones. Add up how many groups you took.',
    '156 ÷ 6',
  ),
  ConceptId.equivalentFractions: ConceptInfo(
    ConceptId.equivalentFractions,
    'Equivalent fractions',
    4,
    'Same-number multiplying',
    'Multiply the top and the bottom by the same number; '
        'the pieces get smaller but the amount stays the same.',
    '2/3 = ?/12',
  ),
};

/// A question built from numbers by code. [diagnosis] is the number a
/// catch-the-mistake explanation says is missing (correct − wrong).
class GeneratedQuestion {
  final ConceptId concept;
  final QuestionStyle style;
  final int seed;
  final List<int> operands;
  final String prompt;
  final String expectedAnswer;
  final int answerValue;
  final int? shownWrong;
  final int? diagnosis;
  final String methodNote;
  final String listenFor;
  final String hint;

  /// The first step done together, between [hint] and [methodNote].
  final String nextStep;

  /// Wrong answers children often give for these numbers.
  final List<Slip> slips;

  /// True when the numbers were read off the child's own worksheet.
  final bool fromWorksheet;

  const GeneratedQuestion({
    required this.concept,
    required this.style,
    required this.seed,
    required this.operands,
    required this.prompt,
    required this.expectedAnswer,
    required this.answerValue,
    this.shownWrong,
    this.diagnosis,
    required this.methodNote,
    required this.listenFor,
    required this.hint,
    this.nextStep = '',
    this.slips = const [],
    this.fromWorksheet = false,
  });

  GeneratedQuestion _copy({
    String? nextStep,
    List<Slip>? slips,
    bool? fromWorksheet,
  }) => GeneratedQuestion(
    concept: concept,
    style: style,
    seed: seed,
    operands: operands,
    prompt: prompt,
    expectedAnswer: expectedAnswer,
    answerValue: answerValue,
    shownWrong: shownWrong,
    diagnosis: diagnosis,
    methodNote: methodNote,
    listenFor: listenFor,
    hint: hint,
    nextStep: nextStep ?? this.nextStep,
    slips: slips ?? this.slips,
    fromWorksheet: fromWorksheet ?? this.fromWorksheet,
  );

  GeneratedQuestion fromTheWorksheet() => _copy(fromWorksheet: true);
}

class QuestionGenerationException implements Exception {
  final String message;
  QuestionGenerationException(this.message);
  @override
  String toString() => 'QuestionGenerationException: $message';
}

/// Builds questions from numbers. Answers come from the classroom method's
/// own steps (partial products, jumps, chunks); [QuestionChecker] then
/// recomputes them a different way before anything is published.
class QuestionGenerator {
  static const tonightStyles = [
    QuestionStyle.solve,
    QuestionStyle.explain,
    QuestionStyle.catchMistake,
  ];

  /// Returns a checked question, retrying with new numbers if a check fails
  /// or if [avoidOperands] would repeat numbers the child has already seen.
  static GeneratedQuestion generateChecked(
    ConceptId concept,
    QuestionStyle style,
    int seed, {
    Set<String> avoidOperands = const {},
  }) {
    for (var attempt = 0; attempt < 50; attempt++) {
      final s = seed + attempt * 7919;
      final q = _generate(concept, style, s);
      if (avoidOperands.contains(q.operands.join(','))) continue;
      if (QuestionChecker.check(q).isEmpty) return q;
    }
    throw QuestionGenerationException(
      'Could not build a checked $style question for $concept',
    );
  }

  /// Three questions for tonight: answer it, explain it, catch a mistake.
  /// Problems read off the worksheet ([worksheet], as operands) are used
  /// first, in order, when they fit the concept and pass the same check as
  /// generated ones; any gap is filled with new numbers. Each question uses
  /// different numbers from the others.
  static List<GeneratedQuestion> tonightSet(
    ConceptId concept,
    int seed, {
    List<List<int>> worksheet = const [],
  }) {
    final used = <String>{};
    final out = <GeneratedQuestion>[];
    for (var i = 0; i < tonightStyles.length; i++) {
      final style = tonightStyles[i];
      GeneratedQuestion? q;
      for (final ops in worksheet) {
        if (used.contains(ops.join(',')) || !fits(concept, style, ops)) {
          continue;
        }
        final candidate = build(concept, style, seed, ops);
        if (QuestionChecker.check(candidate).isEmpty) {
          q = candidate.fromTheWorksheet();
          break;
        }
      }
      q ??= generateChecked(
        concept,
        style,
        seed + i * 104729,
        avoidOperands: used,
      );
      used.add(q.operands.join(','));
      out.add(q);
    }
    return out;
  }

  /// Whether [ops] are numbers this concept's method and its modeled
  /// mistake work for, e.g. a 2-digit × 1-digit product with a carried ten.
  static bool fits(ConceptId concept, QuestionStyle style, List<int> ops) {
    final mistake = style == QuestionStyle.catchMistake;
    switch (concept) {
      case ConceptId.multiply2x1:
        if (ops.length != 2) return false;
        final a = ops[0], b = ops[1];
        return a >= 11 &&
            a <= 99 &&
            a % 10 != 0 &&
            b >= 2 &&
            b <= 9 &&
            (!mistake || (a % 10) * b >= 10);
      case ConceptId.multiply2x2:
        if (ops.length != 2) return false;
        final a = ops[0], b = ops[1];
        return a >= 11 &&
            a <= 99 &&
            b >= 11 &&
            b <= 99 && //
            a % 10 != 0 &&
            b % 10 != 0;
      case ConceptId.addRegroup:
        if (ops.length != 2) return false;
        final a = ops[0], b = ops[1];
        final regroups =
            a % 10 + b % 10 >= 10 || (a ~/ 10) % 10 + (b ~/ 10) % 10 >= 10;
        return a >= 100 && b >= 100 && a + b <= 999 && regroups;
      case ConceptId.subtractCountUp:
        if (ops.length != 2) return false;
        final a = ops[0], b = ops[1];
        final borrows = a % 10 < b % 10 || (a ~/ 10) % 10 < (b ~/ 10) % 10;
        return a <= 999 && b >= 100 && a - b >= 10 && borrows;
      case ConceptId.divideByOneDigit:
        if (ops.length != 2) return false;
        final n = ops[0], d = ops[1];
        if (d < 2 || d > 9 || n % d != 0) return false;
        final q = n ~/ d;
        return q >= 11 && q <= 99 && q % 10 != 0;
      case ConceptId.equivalentFractions:
        if (ops.length != 3) return false;
        final num = ops[0], den = ops[1], k = ops[2];
        return num >= 1 && num < den && den <= 12 && k >= 2 && k <= 10;
    }
  }

  /// Reads a problem as printed on a worksheet ("278 + 146 =", "7 × 46",
  /// "156 ÷ 6", "2/3 = ?/12") into this concept's operands, or null when it
  /// is a different kind of problem.
  static List<int>? parseProblem(ConceptId concept, String text) {
    final t = text
        .replaceAll(RegExp('[−–—]'), '-')
        .replaceAll(RegExp('[xX*·]'), '×')
        .replaceAll(':', '÷');
    if (concept == ConceptId.equivalentFractions) {
      final m = RegExp(
        r'(\d+)\s*/\s*(\d+)\s*=\s*(?:\?|□|_+|\(\s*\)|[a-z])\s*/\s*(\d+)',
      ).firstMatch(t);
      if (m == null) return null;
      final num = int.parse(m[1]!), den = int.parse(m[2]!);
      final big = int.parse(m[3]!);
      if (den == 0 || big % den != 0) return null;
      return [num, den, big ~/ den];
    }
    final m = RegExp(r'(\d+)\s*([-+×÷/])\s*(\d+)').firstMatch(t);
    if (m == null) return null;
    final x = int.parse(m[1]!), op = m[2]!, y = int.parse(m[3]!);
    switch (concept) {
      case ConceptId.addRegroup:
        return op == '+' ? [x, y] : null;
      case ConceptId.subtractCountUp:
        return op == '-' ? [x, y] : null;
      case ConceptId.multiply2x1:
        if (op != '×') return null;
        return x < 10 ? [y, x] : [x, y];
      case ConceptId.multiply2x2:
        return op == '×' ? [x, y] : null;
      case ConceptId.divideByOneDigit:
        return op == '÷' || op == '/' ? [x, y] : null;
      case ConceptId.equivalentFractions:
        return null;
    }
  }

  static GeneratedQuestion _generate(
    ConceptId concept,
    QuestionStyle style,
    int seed,
  ) {
    // Scramble the seed: Dart's Random gives similar first numbers for
    // nearby seeds, which made the three questions look alike.
    final r = Random((seed * 0x9E3779B1 + 0x7F4A7C15) & 0x7FFFFFFF);
    return build(concept, style, seed, _pick(concept, r));
  }

  /// Random numbers in the ranges each concept practises.
  static List<int> _pick(ConceptId concept, Random r) {
    switch (concept) {
      case ConceptId.multiply2x1:
        late int tensDigit, o, b;
        do {
          tensDigit = _between(r, 2, 9);
          o = _between(r, 2, 9);
          b = _between(r, 3, 9);
        } while (o * b < 10); // needs a carried ten so the mistake is visible
        return [tensDigit * 10 + o, b];
      case ConceptId.multiply2x2:
        final ta = _between(r, 1, 4), oa = _between(r, 1, 9);
        final tb = _between(r, 1, 4), ob = _between(r, 1, 9);
        return [ta * 10 + oa, tb * 10 + ob];
      case ConceptId.addRegroup:
        late int a, b;
        do {
          a = _between(r, 120, 699);
          b = _between(r, 110, 399);
        } while (a ~/ 100 + b ~/ 100 > 8 ||
            (a % 10 + b % 10 < 10 && (a ~/ 10) % 10 + (b ~/ 10) % 10 < 10));
        return [a, b];
      case ConceptId.subtractCountUp:
        late int a, b;
        do {
          a = _between(r, 301, 950);
          b = _between(r, 112, a - 60);
        } while (!(a % 10 < b % 10 || (a ~/ 10) % 10 < (b ~/ 10) % 10));
        return [a, b];
      case ConceptId.divideByOneDigit:
        late int d, q;
        do {
          d = _between(r, 3, 9);
          q = _between(r, 12, 39);
        } while (q % 10 == 0);
        return [d * q, d];
      case ConceptId.equivalentFractions:
        late int num, den, k;
        do {
          den = _between(r, 2, 6);
          num = _between(r, 1, den - 1);
          k = _between(r, 2, 5);
        } while (_gcd(num, den) != 1);
        return [num, den, k];
    }
  }

  /// Builds a question from numbers already known to [fits] the concept,
  /// with its coaching: the next step and the common slips.
  static GeneratedQuestion build(
    ConceptId concept,
    QuestionStyle style,
    int seed,
    List<int> ops,
  ) {
    final q = switch (concept) {
      ConceptId.multiply2x1 => _multiply2x1(style, seed, ops),
      ConceptId.multiply2x2 => _multiply2x2(style, seed, ops),
      ConceptId.addRegroup => _addRegroup(style, seed, ops),
      ConceptId.subtractCountUp => _subtractCountUp(style, seed, ops),
      ConceptId.divideByOneDigit => _divide(style, seed, ops),
      ConceptId.equivalentFractions => _fractions(style, seed, ops),
    };
    final (nextStep, slips) = Coaching.forNumbers(concept, ops);
    final wrong = q.shownWrong;
    // On a catch-the-mistake question the likeliest slip is agreeing with
    // the mistake on screen, so it comes first.
    final all = [
      if (wrong != null)
        Slip(answer: wrong, what: 'They agreed with the mistake.', ask: q.hint),
      ...slips,
    ];
    final seen = <int>{q.answerValue};
    return q._copy(
      nextStep: nextStep,
      slips: [
        for (final s in all)
          if (s.answer > 0 && seen.add(s.answer)) s,
      ],
    );
  }

  static int _between(Random r, int lo, int hi) => lo + r.nextInt(hi - lo + 1);

  static GeneratedQuestion _multiply2x1(
    QuestionStyle style,
    int seed,
    List<int> ops,
  ) {
    final a = ops[0], b = ops[1];
    final tensDigit = a ~/ 10, o = a % 10;
    final t = tensDigit * 10;
    final p1 = t * b, p2 = o * b;
    final ans = p1 + p2;
    final carry = p2 ~/ 10;
    final note =
        'Box method: $a = $t + $o. $t × $b = $p1 and $o × $b = $p2. '
        '$p1 + $p2 = $ans.';
    final why =
        'Splits $a into $t and $o, multiplies each by $b ($p1 and $p2), '
        'then adds.';
    final hint = 'Split $a into $t and $o. What is $t × $b?';
    switch (style) {
      case QuestionStyle.solve:
        return GeneratedQuestion(
          concept: ConceptId.multiply2x1,
          style: style,
          seed: seed,
          operands: [a, b],
          prompt: 'What is $a × $b?',
          expectedAnswer: '$ans',
          answerValue: ans,
          methodNote: note,
          listenFor: why,
          hint: hint,
        );
      case QuestionStyle.explain:
        return GeneratedQuestion(
          concept: ConceptId.multiply2x1,
          style: style,
          seed: seed,
          operands: [a, b],
          prompt: 'Show me $a × $b with boxes. What goes in each box?',
          expectedAnswer: '$p1 and $p2, so $ans',
          answerValue: ans,
          methodNote: note,
          listenFor: why,
          hint: hint,
        );
      case QuestionStyle.catchMistake:
        // Standard algorithm with the carried tens forgotten:
        // tens product followed by the ones digit of the ones product.
        final wrong = (tensDigit * b) * 10 + p2 % 10;
        final diff = ans - wrong;
        return GeneratedQuestion(
          concept: ConceptId.multiply2x1,
          style: style,
          seed: seed,
          operands: [a, b],
          prompt:
              'Someone worked out $a × $b and got $wrong. '
              'Are they right? What happened?',
          expectedAnswer:
              'No, it’s $ans. They’re $diff short: the $carry tens from '
              '$o × $b = $p2 never got added.',
          answerValue: ans,
          shownWrong: wrong,
          diagnosis: diff,
          methodNote: note,
          listenFor:
              'Says $wrong is too small and finds the missing $diff '
              '(the $carry tens in $o × $b = $p2).',
          hint: 'What is $o × $b? Where did its $carry tens go?',
        );
    }
  }

  static GeneratedQuestion _multiply2x2(
    QuestionStyle style,
    int seed,
    List<int> ops,
  ) {
    final a = ops[0], b = ops[1];
    final ta = a ~/ 10, oa = a % 10, tb = b ~/ 10, ob = b % 10;
    final p1 = ta * 10 * tb * 10, p2 = ta * 10 * ob;
    final p3 = oa * tb * 10, p4 = oa * ob;
    final ans = p1 + p2 + p3 + p4;
    final note =
        'Area model: ${ta * 10} × ${tb * 10} = $p1, ${ta * 10} × $ob = $p2, '
        '$oa × ${tb * 10} = $p3, $oa × $ob = $p4. Add all four: $ans.';
    final why = 'Fills four boxes ($p1, $p2, $p3, $p4) and adds them.';
    final hint =
        'Make 4 boxes: ${ta * 10} and $oa across, ${tb * 10} and $ob down.';
    final base = GeneratedQuestion(
      concept: ConceptId.multiply2x2,
      style: style,
      seed: seed,
      operands: [a, b],
      prompt: 'What is $a × $b?',
      expectedAnswer: '$ans',
      answerValue: ans,
      methodNote: note,
      listenFor: why,
      hint: hint,
    );
    switch (style) {
      case QuestionStyle.solve:
        return base;
      case QuestionStyle.explain:
        return GeneratedQuestion(
          concept: base.concept,
          style: style,
          seed: seed,
          operands: base.operands,
          prompt: 'Draw the area model for $a × $b. What are the four boxes?',
          expectedAnswer: '$p1, $p2, $p3, $p4, so $ans',
          answerValue: ans,
          methodNote: note,
          listenFor: why,
          hint: hint,
        );
      case QuestionStyle.catchMistake:
        final wrong = p1 + p4;
        final diff = ans - wrong;
        return GeneratedQuestion(
          concept: base.concept,
          style: style,
          seed: seed,
          operands: base.operands,
          prompt:
              'Someone said $a × $b = $wrong. '
              'Are they right? What happened?',
          expectedAnswer:
              'No, it’s $ans. They only did tens × tens and ones × ones and '
              'skipped the two middle boxes ($p2 + $p3 = $diff).',
          answerValue: ans,
          shownWrong: wrong,
          diagnosis: diff,
          methodNote: note,
          listenFor: 'Spots the missing middle boxes, worth $diff together.',
          hint: 'How many boxes does the area model for $a × $b have?',
        );
    }
  }

  static GeneratedQuestion _addRegroup(
    QuestionStyle style,
    int seed,
    List<int> ops,
  ) {
    final a = ops[0], b = ops[1];
    final h = (a ~/ 100 + b ~/ 100) * 100;
    final t = ((a ~/ 10) % 10 + (b ~/ 10) % 10) * 10;
    final o = a % 10 + b % 10;
    final ans = h + t + o;
    final note = 'Partial sums: hundreds $h + tens $t + ones $o = $ans.';
    final why =
        'Adds the hundreds ($h), tens ($t) and ones ($o), then combines.';
    final hint = 'Add the hundreds first. Then the tens. Then the ones.';
    switch (style) {
      case QuestionStyle.solve:
        return GeneratedQuestion(
          concept: ConceptId.addRegroup,
          style: style,
          seed: seed,
          operands: [a, b],
          prompt: 'What is $a + $b?',
          expectedAnswer: '$ans',
          answerValue: ans,
          methodNote: note,
          listenFor: why,
          hint: hint,
        );
      case QuestionStyle.explain:
        return GeneratedQuestion(
          concept: ConceptId.addRegroup,
          style: style,
          seed: seed,
          operands: [a, b],
          prompt:
              'Add $a + $b by hundreds, tens and ones. '
              'What are the three parts?',
          expectedAnswer: '$h, $t and $o, so $ans',
          answerValue: ans,
          methodNote: note,
          listenFor: why,
          hint: hint,
        );
      case QuestionStyle.catchMistake:
        final wrong =
            ((a ~/ 100 + b ~/ 100) % 10) * 100 +
            (((a ~/ 10) % 10 + (b ~/ 10) % 10) % 10) * 10 +
            (a % 10 + b % 10) % 10;
        final diff = ans - wrong;
        return GeneratedQuestion(
          concept: ConceptId.addRegroup,
          style: style,
          seed: seed,
          operands: [a, b],
          prompt:
              'Someone added $a + $b and got $wrong. '
              'Are they right? What happened?',
          expectedAnswer:
              'No, it’s $ans. They’re $diff short: they kept only the last '
              'digit of each column and never carried the extra ten.',
          answerValue: ans,
          shownWrong: wrong,
          diagnosis: diff,
          methodNote: note,
          listenFor:
              'Notices a column made 10 or more and the extra was dropped.',
          hint: 'What do the ones add up to? Is that more than 9?',
        );
    }
  }

  /// Landmarks used when counting up from [b] to [a]: next ten, next
  /// hundred, the hundred below [a], the ten below [a], then [a].
  static List<int> countUpLandmarks(int b, int a) {
    final candidates = [
      ((b + 9) ~/ 10) * 10,
      ((b + 99) ~/ 100) * 100,
      (a ~/ 100) * 100,
      (a ~/ 10) * 10,
      a,
    ];
    final out = <int>[];
    var cur = b;
    for (final c in candidates) {
      if (c > cur && c <= a) {
        out.add(c);
        cur = c;
      }
    }
    return out;
  }

  static GeneratedQuestion _subtractCountUp(
    QuestionStyle style,
    int seed,
    List<int> ops,
  ) {
    final a = ops[0], b = ops[1];
    final landmarks = countUpLandmarks(b, a);
    var cur = b;
    final jumps = <int>[];
    final steps = <String>[];
    for (final l in landmarks) {
      jumps.add(l - cur);
      steps.add('+${l - cur} → $l');
      cur = l;
    }
    final ans = jumps.fold<int>(0, (s, j) => s + j);
    final note =
        'Count up from $b: ${steps.join(', ')}. '
        'Jumps: ${jumps.join(' + ')} = $ans.';
    final why =
        'Jumps from $b to friendly numbers up to $a and adds the jumps.';
    final hint = 'Start at $b. How far to the next ten?';
    switch (style) {
      case QuestionStyle.solve:
        return GeneratedQuestion(
          concept: ConceptId.subtractCountUp,
          style: style,
          seed: seed,
          operands: [a, b],
          prompt: 'What is $a − $b?',
          expectedAnswer: '$ans',
          answerValue: ans,
          methodNote: note,
          listenFor: why,
          hint: hint,
        );
      case QuestionStyle.explain:
        return GeneratedQuestion(
          concept: ConceptId.subtractCountUp,
          style: style,
          seed: seed,
          operands: [a, b],
          prompt: 'Count up from $b to $a. What jumps did you make?',
          expectedAnswer: '${jumps.join(' + ')} = $ans',
          answerValue: ans,
          methodNote: note,
          listenFor: why,
          hint: hint,
        );
      case QuestionStyle.catchMistake:
        final wrong =
            ((a ~/ 100) - (b ~/ 100)).abs() * 100 +
            (((a ~/ 10) % 10) - ((b ~/ 10) % 10)).abs() * 10 +
            ((a % 10) - (b % 10)).abs();
        return GeneratedQuestion(
          concept: ConceptId.subtractCountUp,
          style: style,
          seed: seed,
          operands: [a, b],
          prompt:
              'Someone did $a − $b and got $wrong. '
              'Are they right? What happened?',
          expectedAnswer:
              'No, it’s $ans. In a column where the top digit was smaller, '
              'they took the top from the bottom instead.',
          answerValue: ans,
          shownWrong: wrong,
          methodNote: note,
          listenFor:
              'Checks by counting up from $b and finds $ans, '
              'or spots the flipped column.',
          hint: 'Count up from $b to $a. How far is it really?',
        );
    }
  }

  static GeneratedQuestion _divide(
    QuestionStyle style,
    int seed,
    List<int> ops,
  ) {
    final n = ops[0], d = ops[1];
    final q = n ~/ d;
    final q10 = (q ~/ 10) * 10, q1 = q % 10;
    final chunk = q10 * d, rest = n - chunk;
    final ans = q10 + q1;
    final note =
        'Partial quotients: $q10 × $d = $chunk. $n − $chunk = $rest. '
        '$q1 × $d = $rest. $q10 + $q1 = $ans.';
    final why =
        'Takes a big chunk ($q10 groups = $chunk), then $q1 more groups.';
    final hint = 'How many is 10 groups of $d? Can you take more than that?';
    switch (style) {
      case QuestionStyle.solve:
        return GeneratedQuestion(
          concept: ConceptId.divideByOneDigit,
          style: style,
          seed: seed,
          operands: [n, d],
          prompt: 'What is $n ÷ $d?',
          expectedAnswer: '$ans',
          answerValue: ans,
          methodNote: note,
          listenFor: why,
          hint: hint,
        );
      case QuestionStyle.explain:
        return GeneratedQuestion(
          concept: ConceptId.divideByOneDigit,
          style: style,
          seed: seed,
          operands: [n, d],
          prompt: 'How many groups of $d fit in $n? Show me your chunks.',
          expectedAnswer: '$q10 groups and $q1 groups, so $ans',
          answerValue: ans,
          methodNote: note,
          listenFor: why,
          hint: hint,
        );
      case QuestionStyle.catchMistake:
        final wrong = q10;
        return GeneratedQuestion(
          concept: ConceptId.divideByOneDigit,
          style: style,
          seed: seed,
          operands: [n, d],
          prompt:
              'Someone said $n ÷ $d = $wrong. Are they right? What happened?',
          expectedAnswer:
              'No, it’s $ans. $wrong × $d is only $chunk; $rest is left, '
              'which is $q1 more groups.',
          answerValue: ans,
          shownWrong: wrong,
          diagnosis: q1,
          methodNote: note,
          listenFor: 'Checks $wrong × $d = $chunk and sees $rest is left over.',
          hint: 'What is $wrong × $d? Is anything left over?',
        );
    }
  }

  static int _gcd(int a, int b) => b == 0 ? a : _gcd(b, a % b);

  static GeneratedQuestion _fractions(
    QuestionStyle style,
    int seed,
    List<int> ops,
  ) {
    final num = ops[0], den = ops[1], k = ops[2];
    final big = den * k;
    final ans = num * k;
    final note =
        'Multiply top and bottom by $k: $num/$den = $num×$k / $den×$k = '
        '$ans/$big.';
    final why =
        'Says the bottom was multiplied by $k, so the top must be too. '
        'Each piece was cut into $k smaller pieces.';
    final hint = 'What do you multiply $den by to get $big?';
    switch (style) {
      case QuestionStyle.solve:
        return GeneratedQuestion(
          concept: ConceptId.equivalentFractions,
          style: style,
          seed: seed,
          operands: [num, den, k],
          prompt: '$num/$den = ?/$big. What goes on top?',
          expectedAnswer: '$ans (so $ans/$big)',
          answerValue: ans,
          methodNote: note,
          listenFor: why,
          hint: hint,
        );
      case QuestionStyle.explain:
        return GeneratedQuestion(
          concept: ConceptId.equivalentFractions,
          style: style,
          seed: seed,
          operands: [num, den, k],
          prompt: 'Why is $num/$den the same amount as $ans/$big?',
          expectedAnswer:
              'Top and bottom were both multiplied by $k, so it’s $ans/$big',
          answerValue: ans,
          methodNote: note,
          listenFor: why,
          hint: hint,
        );
      case QuestionStyle.catchMistake:
        final wrong = num + (big - den);
        return GeneratedQuestion(
          concept: ConceptId.equivalentFractions,
          style: style,
          seed: seed,
          operands: [num, den, k],
          prompt:
              'Someone said $num/$den = $wrong/$big because they added '
              '${big - den} to the bottom and the top. Are they right?',
          expectedAnswer:
              'No, it’s $ans/$big. You multiply top and bottom by the same '
              'number ($k). Adding changes the amount.',
          answerValue: ans,
          shownWrong: wrong,
          methodNote: note,
          listenFor: 'Says you multiply, not add, and gets $ans/$big.',
          hint: hint,
        );
    }
  }
}

/// What to do when the child is stuck or says something else: the next
/// step to take together, and the wrong answers children typically give for
/// these numbers (a forgotten carry, a skipped box, adding instead of
/// multiplying), each with what probably happened and a question to ask.
/// All of it is arithmetic on the numbers; [QuestionChecker] recomputes
/// every slip on its own.
class Coaching {
  static (String, List<Slip>) forNumbers(ConceptId concept, List<int> ops) {
    switch (concept) {
      case ConceptId.multiply2x1:
        return _multiply2x1(ops[0], ops[1]);
      case ConceptId.multiply2x2:
        return _multiply2x2(ops[0], ops[1]);
      case ConceptId.addRegroup:
        return _addRegroup(ops[0], ops[1]);
      case ConceptId.subtractCountUp:
        return _subtract(ops[0], ops[1]);
      case ConceptId.divideByOneDigit:
        return _divide(ops[0], ops[1]);
      case ConceptId.equivalentFractions:
        return _fractions(ops[0], ops[1], ops[2]);
    }
  }

  static (String, List<Slip>) _multiply2x1(int a, int b) {
    final td = a ~/ 10, o = a % 10, t = td * 10;
    final p1 = t * b, p2 = o * b, ans = p1 + p2, carry = p2 ~/ 10;
    final timesTable =
        'Let’s check each box: what is $t × $b? What is $o × $b?';
    return (
      '$t × $b = $p1. Now: what is $o × $b? Then add the two.',
      [
        Slip(
          answer: td * b * 10 + p2 % 10,
          what: 'The $carry tens from $o × $b = $p2 got lost.',
          ask: 'What is $o × $b? Where did the ${carry * 10} go?',
        ),
        Slip(
          answer: td * b + p2,
          what: 'They did $td × $b instead of $t × $b.',
          ask: 'Is the $td in $a worth $td, or $t?',
        ),
        Slip(
          answer: t + p2,
          what: 'Only the $o got multiplied; the $t didn’t.',
          ask: 'We need $b groups of $a. Did the $t get multiplied by $b too?',
        ),
        Slip(
          answer: a + b,
          what: 'They added instead of multiplying.',
          ask: 'Is it $a plus $b, or $b groups of $a?',
        ),
        Slip(
          answer: int.parse('${td * b}$p2'),
          what: 'They wrote ${td * b} and $p2 side by side.',
          ask: '$t × $b is $p1, not ${td * b}. What is $p1 + $p2?',
        ),
        Slip(
          answer: ans - b,
          what: 'One group of $b short: likely a times-table slip.',
          ask: timesTable,
        ),
        Slip(
          answer: ans + b,
          what: 'One group of $b too many: likely a times-table slip.',
          ask: timesTable,
        ),
      ],
    );
  }

  static (String, List<Slip>) _multiply2x2(int a, int b) {
    final ta = a ~/ 10 * 10, oa = a % 10, tb = b ~/ 10 * 10, ob = b % 10;
    final p1 = ta * tb, p2 = ta * ob, p3 = oa * tb, p4 = oa * ob;
    final ans = p1 + p2 + p3 + p4;
    const count = 'Count the boxes: did all four get added?';
    const addAgain = 'The boxes look right. Let’s add the four again, slowly.';
    return (
      'First box: $ta × $tb = $p1. Now fill the other three: '
          '$ta × $ob, $oa × $tb and $oa × $ob.',
      [
        Slip(
          answer: p1 + p4,
          what: 'They skipped the two middle boxes ($p2 and $p3).',
          ask: 'How many boxes does the area model have? Which are missing?',
        ),
        Slip(
          answer: a * ob + a * (tb ~/ 10),
          what: 'The second row lost its zero: $a × $tb is ${a * tb}.',
          ask: 'In $b, is the ${tb ~/ 10} worth ${tb ~/ 10}, or $tb?',
        ),
        Slip(
          answer: ans - p3,
          what: 'A middle box is missing ($oa × $tb = $p3).',
          ask: count,
        ),
        Slip(
          answer: ans - p2,
          what: 'A middle box is missing ($ta × $ob = $p2).',
          ask: count,
        ),
        for (final off in const [-100, -10, 10, 100])
          Slip(
            answer: ans + off,
            what: 'The boxes are fine; the adding slipped by ${off.abs()}.',
            ask: addAgain,
          ),
      ],
    );
  }

  static (String, List<Slip>) _addRegroup(int a, int b) {
    final ha = a ~/ 100 * 100, hb = b ~/ 100 * 100;
    final ta = (a ~/ 10) % 10 * 10, tb = (b ~/ 10) % 10 * 10;
    final h = ha + hb, t = ta + tb, o = a % 10 + b % 10;
    final ans = h + t + o;
    return (
      'Hundreds: $ha + $hb = $h. Tens: $ta + $tb = $t. '
          'Now the ones: ${a % 10} + ${b % 10}. Then put the three parts together.',
      [
        Slip(
          answer: (h ~/ 100 % 10) * 100 + (t ~/ 10 % 10) * 10 + o % 10,
          what:
              'They kept only the last digit of a column and dropped the '
              'extra ten.',
          ask: 'What do the ones add up to? Where does the extra ten go?',
        ),
        Slip(
          answer: int.parse('${h ~/ 100}${t ~/ 10}$o'),
          what: 'They wrote each column’s total side by side.',
          ask: 'When a column makes 10 or more, where does the extra go?',
        ),
        if (o >= 10)
          Slip(
            answer: ans - 10,
            what: 'The ten carried from the ones never got added.',
            ask: 'The ones make $o. Where did that extra ten go?',
          ),
        if (t >= 100)
          Slip(
            answer: ans - 100,
            what: 'The hundred carried from the tens never got added.',
            ask: 'The tens make $t. Where did that extra hundred go?',
          ),
        Slip(
          answer: a - b,
          what: 'They took away instead of adding.',
          ask: 'Should the answer be bigger or smaller than $a?',
        ),
      ],
    );
  }

  static (String, List<Slip>) _subtract(int a, int b) {
    final landmarks = QuestionGenerator.countUpLandmarks(b, a);
    final jumps = <int>[];
    var cur = b;
    for (final l in landmarks) {
      jumps.add(l - cur);
      cur = l;
    }
    final ans = a - b;
    final borrowOnes = a % 10 < b % 10;
    final tensTop = (a ~/ 10) % 10 - (borrowOnes ? 1 : 0);
    final borrowTens = tensTop < (b ~/ 10) % 10;
    final first = landmarks.first;
    return (
      first == a
          ? 'Start at $b and count up in tens. How many tens to $a?'
          : 'From $b, jump +${jumps.first} to $first. '
                'Where is the next friendly number?',
      [
        Slip(
          answer:
              ((a ~/ 100) - (b ~/ 100)).abs() * 100 +
              (((a ~/ 10) % 10) - ((b ~/ 10) % 10)).abs() * 10 +
              ((a % 10) - (b % 10)).abs(),
          what:
              'Where the top digit was smaller, they took the top from the '
              'bottom.',
          ask: 'Count up from $b to $a. How far is it?',
        ),
        if (borrowOnes)
          Slip(
            answer: ans + 10,
            what:
                'They borrowed a ten for the ones but didn’t take it off '
                'the tens.',
            ask: 'When you borrow a ten, what happens to the tens?',
          ),
        if (borrowTens)
          Slip(
            answer: ans + 100,
            what:
                'They borrowed a hundred but didn’t take it off the '
                'hundreds.',
            ask: 'When you borrow a hundred, what happens to the hundreds?',
          ),
        Slip(
          answer: a + b,
          what: 'They added instead of taking away.',
          ask: 'Should the answer be bigger or smaller than $a?',
        ),
        if (jumps.length > 1)
          for (final j in jumps)
            Slip(
              answer: ans - j,
              what: 'Counting up, they missed the +$j jump.',
              ask: 'Let’s list the jumps again, starting at $b.',
            ),
      ],
    );
  }

  static (String, List<Slip>) _divide(int n, int d) {
    final q = n ~/ d, q10 = q ~/ 10 * 10, q1 = q % 10;
    final chunk = q10 * d, rest = n - chunk;
    final check = 'Multiply your answer by $d. Do you get $n?';
    return (
      '$q10 groups of $d is $chunk. $n − $chunk = $rest left. '
          'How many groups of $d fit in $rest?',
      [
        Slip(
          answer: q10,
          what:
              'They took the big chunk ($q10 groups) and stopped; $rest is '
              'still left.',
          ask: 'What is $q10 × $d? Is anything left over?',
        ),
        Slip(answer: q1, what: 'They counted only the last chunk.', ask: check),
        Slip(answer: q - 1, what: 'One group of $d off.', ask: check),
        Slip(answer: q + 1, what: 'One group of $d off.', ask: check),
        Slip(
          answer: n * d,
          what: 'They multiplied instead of dividing.',
          ask: 'Should the answer be bigger or smaller than $n?',
        ),
        Slip(
          answer: n - d,
          what: 'They took away $d once instead of counting groups.',
          ask: 'How many groups of $d fit in $n?',
        ),
      ],
    );
  }

  static (String, List<Slip>) _fractions(int num, int den, int k) {
    final big = den * k;
    return (
      '$den × $k = $big, so we multiply by $k. Now do the same to the top: '
          'what is $num × $k?',
      [
        Slip(
          answer: num + big - den,
          what:
              'They added ${big - den} to the top and bottom instead of '
              'multiplying.',
          ask:
              'What did you multiply $den by to get $big? Do the same to '
              'the top.',
        ),
        Slip(
          answer: num,
          what: 'They kept the top the same.',
          ask: 'The bottom got $k times bigger. What happens to the top?',
        ),
        Slip(
          answer: num * big,
          what: 'They multiplied the top by $big instead of by $k.',
          ask: 'What do you multiply $den by to get $big?',
        ),
        Slip(
          answer: k,
          what: 'They gave the number to multiply by, not the new top.',
          ask: 'Yes, it’s × $k. Now what is $num × $k?',
        ),
      ],
    );
  }
}

/// Independent re-check of a generated question. Recomputes the answer with
/// plain arithmetic and the modeled mistake with digit-by-digit string work,
/// so a bug in one implementation can't silently confirm itself.
class QuestionChecker {
  static List<String> check(GeneratedQuestion q) {
    final problems = <String>[];
    final ops = q.operands;
    int correct;
    switch (q.concept) {
      case ConceptId.multiply2x1:
      case ConceptId.multiply2x2:
        correct = ops[0] * ops[1];
      case ConceptId.addRegroup:
        correct = ops[0] + ops[1];
      case ConceptId.subtractCountUp:
        correct = ops[0] - ops[1];
      case ConceptId.divideByOneDigit:
        if (ops[0] % ops[1] != 0) problems.add('division has a remainder');
        correct = ops[0] ~/ ops[1];
      case ConceptId.equivalentFractions:
        correct = ops[0] * ops[2];
    }
    if (q.answerValue != correct) {
      problems.add('answer ${q.answerValue} != $correct');
    }
    if (!_mentions(q.expectedAnswer, correct)) {
      problems.add('expected answer text does not contain $correct');
    }
    if (!_mentions(q.methodNote, correct)) {
      problems.add('method note does not reach $correct');
    }
    if (q.style == QuestionStyle.catchMistake) {
      final wrong = q.shownWrong;
      if (wrong == null) {
        problems.add('catch question has no wrong answer');
      } else {
        if (wrong == correct) problems.add('wrong answer equals correct');
        final modeled = _misconception(q.concept, ops);
        if (modeled != wrong) {
          problems.add('wrong $wrong does not match modeled mistake $modeled');
        }
        if (!_mentions(q.prompt, wrong)) {
          problems.add('prompt does not show $wrong');
        }
        if (!q.expectedAnswer.startsWith('No')) {
          problems.add('catch answer must say the shown answer is wrong');
        }
      }
      final diag = q.diagnosis;
      if (diag != null && wrong != null) {
        final expectedDiag = correct - wrong;
        if (diag != expectedDiag) {
          problems.add('diagnosis $diag != $expectedDiag');
        }
        if (!_mentions(q.expectedAnswer, diag)) {
          problems.add('explanation does not name the missing $diag');
        }
      }
    }
    _checkCoaching(q, correct, problems);
    return problems;
  }

  /// Help must never hand over the answer, and every slip must be a real
  /// modeled mistake for these numbers, recomputed here digit by digit.
  static void _checkCoaching(
    GeneratedQuestion q,
    int correct,
    List<String> problems,
  ) {
    // Help may name other numbers that happen to match the answer ("36
    // left"); a giveaway states it as a result ("= 322", "is 322"). Small
    // answers and ones already on screen don't count.
    final result = RegExp(
      r'(=|\bis)\s*'
      '$correct'
      r'(?![0-9/])',
    );
    bool givesAway(String text) =>
        correct >= 10 && !_mentions(q.prompt, correct) && result.hasMatch(text);
    if (givesAway(q.hint)) problems.add('hint gives the answer away');
    if (q.nextStep.isEmpty) problems.add('no next step');
    if (givesAway(q.nextStep)) problems.add('next step gives the answer away');
    final known = _knownSlips(q.concept, q.operands, correct);
    if (q.shownWrong != null) known.add(q.shownWrong!);
    final seen = <int>{};
    for (final slip in q.slips) {
      final a = slip.answer;
      if (a == correct) problems.add('slip $a is the right answer');
      if (a <= 0) problems.add('slip $a is not a positive number');
      if (!seen.add(a)) problems.add('slip $a is listed twice');
      if (!known.contains(a)) problems.add('slip $a is not a modeled mistake');
      if (givesAway(slip.ask)) problems.add('slip $a gives the answer away');
    }
  }

  static Set<int> _knownSlips(ConceptId concept, List<int> ops, int correct) {
    String s(int n) => n.toString();
    int digit(String str, int i) => int.parse(str[i]);
    final known = {_misconception(concept, ops)};
    switch (concept) {
      case ConceptId.multiply2x1:
        final a = s(ops[0]);
        final b = ops[1];
        final tens = digit(a, 0), ones = digit(a, 1);
        known.addAll([
          tens * b + ones * b,
          int.parse('${tens}0') + ones * b,
          ops[0] + b,
          int.parse('${tens * b}${ones * b}'),
          correct - b,
          correct + b,
        ]);
      case ConceptId.multiply2x2:
        final a = s(ops[0]), b = s(ops[1]);
        known.addAll([
          ops[0] * digit(b, 1) + ops[0] * digit(b, 0),
          correct - int.parse('${digit(a, 1) * digit(b, 0)}0'),
          correct - int.parse('${digit(a, 0) * digit(b, 1)}0'),
          for (final off in const [10, 100]) ...[correct - off, correct + off],
        ]);
      case ConceptId.addRegroup:
        final a = s(ops[0]).padLeft(3, '0'), b = s(ops[1]).padLeft(3, '0');
        final cols = [for (var i = 0; i < 3; i++) digit(a, i) + digit(b, i)];
        known.addAll([
          int.parse(cols.join()),
          if (cols[2] >= 10) correct - 10,
          if (cols[1] >= 10) correct - 100,
          ops[0] - ops[1],
        ]);
      case ConceptId.subtractCountUp:
        final a = s(ops[0]).padLeft(3, '0'), b = s(ops[1]).padLeft(3, '0');
        final borrowOnes = digit(a, 2) < digit(b, 2);
        final borrowTens = digit(a, 1) - (borrowOnes ? 1 : 0) < digit(b, 1);
        known.addAll([
          ops[0] + ops[1],
          if (borrowOnes) correct + 10,
          if (borrowTens) correct + 100,
          for (final j in _countUpJumps(ops[1], ops[0])) correct - j,
        ]);
      case ConceptId.divideByOneDigit:
        final q = s(correct);
        known.addAll([
          digit(q, q.length - 1),
          correct - 1,
          correct + 1,
          ops[0] * ops[1],
          ops[0] - ops[1],
        ]);
      case ConceptId.equivalentFractions:
        known.addAll([ops[0], ops[0] * ops[1] * ops[2], ops[2]]);
    }
    return known;
  }

  /// Counting up from [from] to [to] by friendly numbers, written as a walk:
  /// to a round ten, a round hundred, whole hundreds, whole tens, then ones.
  static List<int> _countUpJumps(int from, int to) {
    final jumps = <int>[];
    var at = from;
    void jumpTo(int target) {
      if (target > at && target <= to) {
        jumps.add(target - at);
        at = target;
      }
    }

    jumpTo(at + (10 - at % 10) % 10);
    jumpTo(at + (100 - at % 100) % 100);
    jumpTo(to - to % 100);
    jumpTo(to - to % 10);
    jumpTo(to);
    return jumps;
  }

  static bool _mentions(String text, int n) =>
      RegExp('(?<![0-9])$n(?![0-9])').hasMatch(text);

  static int _misconception(ConceptId concept, List<int> ops) {
    String s(int n) => n.toString();
    int digit(String str, int i) => int.parse(str[i]);
    switch (concept) {
      case ConceptId.multiply2x1:
        final a = s(ops[0]);
        final b = ops[1];
        return int.parse('${digit(a, 0) * b}${(digit(a, 1) * b) % 10}');
      case ConceptId.multiply2x2:
        final a = s(ops[0]), b = s(ops[1]);
        return digit(a, 0) * digit(b, 0) * 100 + digit(a, 1) * digit(b, 1);
      case ConceptId.addRegroup:
        final a = s(ops[0]).padLeft(3, '0'), b = s(ops[1]).padLeft(3, '0');
        return int.parse(
          List.generate(3, (i) => (digit(a, i) + digit(b, i)) % 10).join(),
        );
      case ConceptId.subtractCountUp:
        final a = s(ops[0]).padLeft(3, '0'), b = s(ops[1]).padLeft(3, '0');
        return int.parse(
          List.generate(3, (i) => (digit(a, i) - digit(b, i)).abs()).join(),
        );
      case ConceptId.divideByOneDigit:
        final q = ops[0] ~/ ops[1];
        return q - q % 10;
      case ConceptId.equivalentFractions:
        return ops[0] + ops[1] * ops[2] - ops[1];
    }
  }
}
