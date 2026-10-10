import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../family/family_service.dart';
import '../generated/protocol.dart';
import '../math/concepts.dart';
import '../rechecks/recheck_service.dart';

/// Builds question cards from checked questions and records parents' marks.
class CardService {
  static int newSeed() => Random.secure().nextInt(1 << 30);

  static Question _toRow(
    GeneratedQuestion g,
    int cardId,
    int familyId,
    int i, {
    int? variantOf,
  }) {
    return Question(
      cardId: cardId,
      familyId: familyId,
      position: i,
      conceptId: g.concept,
      style: g.style,
      seed: g.seed,
      operands: g.operands,
      prompt: g.prompt,
      expectedAnswer: g.expectedAnswer,
      answerValue: g.answerValue,
      shownWrong: g.shownWrong,
      methodNote: g.methodNote,
      listenFor: g.listenFor,
      hint: g.hint,
      checkedByCode: QuestionChecker.check(g).isEmpty,
      fromWorksheet: g.fromWorksheet,
      variantOfQuestionId: variantOf,
    );
  }

  /// Tonight's card: solve, explain, catch-the-mistake. Problems read off the
  /// worksheet ([worksheetProblems], as printed) are used when they fit the
  /// concept. Generation and the independent check both run before the card
  /// exists, so a parent never sees an unchecked answer.
  static Future<QuestionCard> createTonightCard(
    Session session,
    int familyId,
    ConceptId concept, {
    List<String> worksheetProblems = const [],
    int? seed,
    Transaction? transaction,
  }) async {
    final generated = QuestionGenerator.tonightSet(
      concept,
      seed ?? newSeed(),
      worksheet: [
        for (final p in worksheetProblems)
          ?QuestionGenerator.parseProblem(concept, p),
      ],
    );
    Future<QuestionCard> run(Transaction tx) async {
      final card = await QuestionCard.db.insertRow(
        session,
        QuestionCard(
          familyId: familyId,
          conceptId: concept,
          kind: CardKind.tonight,
          recheckDay: 0,
        ),
        transaction: tx,
      );
      await Question.db.insert(
        session,
        [
          for (var i = 0; i < generated.length; i++)
            _toRow(generated[i], card.id!, familyId, i),
        ],
        transaction: tx,
      );
      return card;
    }

    return transaction != null ? run(transaction) : session.db.transaction(run);
  }

  /// A re-check card: a new-number variant of each source question, same
  /// concept and same style.
  static Future<QuestionCard> createRecheckCard(
    Session session, {
    required QuestionCard source,
    required List<Question> sourceQuestions,
    required int day,
    int? seed,
  }) async {
    final base = seed ?? newSeed();
    final seen = (await Question.db.find(
      session,
      where: (t) =>
          t.familyId.equals(source.familyId) &
          t.conceptId.equals(source.conceptId),
    )).map((q) => q.operands.join(',')).toSet();
    final variants = <(GeneratedQuestion, int)>[];
    for (var i = 0; i < sourceQuestions.length; i++) {
      final q = sourceQuestions[i];
      final g = QuestionGenerator.generateChecked(
        q.conceptId,
        q.style,
        base + i * 104729,
        avoidOperands: seen,
      );
      seen.add(g.operands.join(','));
      variants.add((g, q.id!));
    }
    return session.db.transaction((tx) async {
      final card = await QuestionCard.db.insertRow(
        session,
        QuestionCard(
          familyId: source.familyId,
          conceptId: source.conceptId,
          kind: CardKind.recheck,
          recheckDay: day,
          sourceCardId: source.id,
        ),
        transaction: tx,
      );
      await Question.db.insert(
        session,
        [
          for (var i = 0; i < variants.length; i++)
            _toRow(
              variants[i].$1,
              card.id!,
              source.familyId,
              i,
              variantOf: variants[i].$2,
            ),
        ],
        transaction: tx,
      );
      return card;
    });
  }

  static Future<List<Question>> questionsOf(Session session, int cardId) {
    return Question.db.find(
      session,
      where: (t) => t.cardId.equals(cardId),
      orderBy: (t) => t.position,
    );
  }

  /// Latest mark per question across both parents, by the time it was made
  /// on the phone (offline marks keep their original time).
  static Mark? latestOf(List<Mark> marks) {
    if (marks.isEmpty) return null;
    return marks.reduce((a, b) {
      final c = a.markedAt.compareTo(b.markedAt);
      if (c != 0) return c > 0 ? a : b;
      return a.id! > b.id! ? a : b;
    });
  }

  static Future<CardView> view(Session session, QuestionCard card) async {
    final questions = await questionsOf(session, card.id!);
    final marks = await Mark.db.find(
      session,
      where: (t) => t.cardId.equals(card.id!),
      orderBy: (t) => t.markedAt,
    );
    final info = conceptInfos[card.conceptId]!;
    return CardView(
      card: card,
      conceptTitle: info.title,
      methodName: info.methodName,
      methodLine: info.methodLine,
      grade: info.grade,
      questions: [
        for (final q in questions)
          () {
            final mine = marks.where((m) => m.questionId == q.id).toList();
            return QuestionView(
              question: q,
              marks: mine,
              latest: latestOf(mine),
            );
          }(),
      ],
    );
  }

  static const _outcomeWords = {
    Outcome.notYet: 'not yet',
    Outcome.withHint: 'got it with a hint',
    Outcome.gotAnswer: 'got the answer',
    Outcome.explainedWhy: 'explained why',
  };

  /// Stores marks idempotently by clientMarkId, so an offline phone can
  /// safely resend its whole queue. Returns the ids the server now holds.
  static Future<List<String>> recordMarks(
    Session session,
    FamilyMember member,
    List<MarkInput> inputs,
  ) async {
    final accepted = <String>[];
    final touchedCards = <int>{};
    final events = <(int, String)>[];
    final now = DateTime.now().toUtc();
    for (final input in inputs) {
      final existing = await Mark.db.findFirstRow(
        session,
        where: (t) => t.clientMarkId.equals(input.clientMarkId),
      );
      if (existing != null) {
        accepted.add(input.clientMarkId);
        continue;
      }
      final question = await Question.db.findById(session, input.questionId);
      if (question == null || question.familyId != member.familyId) continue;
      // A phone clock running ahead must not win every future conflict.
      final markedAt = input.markedAt.isAfter(now)
          ? now
          : input.markedAt.toUtc();
      await Mark.db.insertRow(
        session,
        Mark(
          questionId: question.id!,
          cardId: question.cardId,
          familyId: member.familyId,
          outcome: input.outcome,
          parentName: member.displayName,
          authUserId: session.authenticated!.authUserId,
          clientMarkId: input.clientMarkId,
          markedAt: markedAt,
        ),
      );
      accepted.add(input.clientMarkId);
      touchedCards.add(question.cardId);
      events.add((
        question.cardId,
        '${member.displayName}: Q${question.position + 1} '
            '${_outcomeWords[input.outcome]}',
      ));
    }
    for (final cardId in touchedCards) {
      await _afterMarks(session, cardId);
    }
    for (final (cardId, message) in events) {
      await FamilyService.postEvent(
        session,
        member.familyId,
        kind: 'mark',
        message: message,
        actorName: member.displayName,
        cardId: cardId,
      );
    }
    return accepted;
  }

  static Future<void> _afterMarks(Session session, int cardId) async {
    final card = await QuestionCard.db.findById(session, cardId);
    if (card == null) return;
    final questions = await questionsOf(session, cardId);
    final marked = (await Mark.db.find(
      session,
      where: (t) => t.cardId.equals(cardId),
    )).map((m) => m.questionId).toSet();
    final complete = questions.every((q) => marked.contains(q.id));
    if (complete && card.completedAt == null) {
      await QuestionCard.db.updateRow(
        session,
        card.copyWith(completedAt: DateTime.now().toUtc()),
      );
    }
    if (complete && card.kind == CardKind.tonight) {
      await RecheckService.ensureScheduled(session, card);
    }
  }
}
