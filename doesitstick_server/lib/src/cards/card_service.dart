import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_offline_sync_server/serverpod_offline_sync_server.dart';

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
      return a.id!.toString().compareTo(b.id!.toString()) > 0 ? a : b;
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

  /// The web app's online path (phones sync marks with offline sync
  /// instead): writes marks into the family's sync space on the server, so
  /// the partner's phone receives them too. The clientMarkId becomes the
  /// mark's UUID, so re-sending a queue is idempotent. Returns the ids the
  /// server now holds.
  static Future<List<String>> recordMarks(
    Session session,
    FamilyMember member,
    List<MarkInput> inputs,
  ) async {
    final accepted = <String>[];
    final now = DateTime.now().toUtc();
    final user = session.authenticated!.authUserId;
    final space = await FamilyService.ensureSpace(session, member.familyId);
    for (final input in inputs) {
      final id = markId(input.clientMarkId);
      if (await Mark.db.findById(session, id) != null) {
        accepted.add(input.clientMarkId);
        continue;
      }
      final question = await Question.db.findById(session, input.questionId);
      if (question == null || question.familyId != member.familyId) continue;
      // A phone clock running ahead must not win every future conflict.
      final markedAt = input.markedAt.isAfter(now)
          ? now
          : input.markedAt.toUtc();
      final db = syncDatabase(session);
      await db.transactionForUser(
        user,
        (tx) => db.insertRow<Mark>(
          Mark(
            id: id,
            questionId: question.id!,
            cardId: question.cardId,
            familyId: member.familyId,
            outcome: input.outcome,
            parentName: member.displayName,
            authUserId: user,
            markedAt: markedAt,
          ),
          transaction: tx,
        ),
        spaceId: space,
      );
      accepted.add(input.clientMarkId);
    }
    await afterSync(session, member);
    return accepted;
  }

  /// The CRDT-aware database for [session]: the session's own on a running
  /// server. Under serverpod_test the session's database is a rollback proxy
  /// that hides it, so the proxy is wrapped with the sync engine here.
  static OfflineSyncDatabase syncDatabase(Session session) {
    final db = session.db;
    if (db is OfflineSyncDatabase) return db;
    return offlineSyncDatabaseInterceptor(session, db) as OfflineSyncDatabase;
  }

  /// A mark's id from the phone: a UUID already, or (older phones) any
  /// string, mapped to a stable UUID.
  static UuidValue markId(String clientMarkId) {
    try {
      return UuidValue.withValidation(clientMarkId);
    } on FormatException {
      return UuidValue.fromString(
        const Uuid().v5(Namespace.url.value, 'mark:$clientMarkId'),
      );
    }
  }

  /// Marks already announced to the family, by family id. Kept in memory;
  /// after a restart only recent marks are announced.
  static final _announced = <int, Set<UuidValue>>{};

  /// Runs after a parent's marks reach the server, by offline sync or the
  /// web endpoint: completes cards, schedules their re-checks, and tells the
  /// other parent's phone what was marked.
  static Future<void> afterSync(Session session, FamilyMember member) async {
    final since = DateTime.now().toUtc().subtract(const Duration(days: 9));
    final cards = await QuestionCard.db.find(
      session,
      where: (t) => t.familyId.equals(member.familyId) & (t.createdAt > since),
    );
    final marks = await Mark.db.find(
      session,
      where: (t) => t.cardId.inSet(cards.map((c) => c.id!).toSet()),
    );
    // After a restart nothing is remembered: treat anything older than a
    // couple of minutes as already announced, and announce the rest.
    final recent = DateTime.now().toUtc().subtract(const Duration(minutes: 2));
    final known =
        _announced[member.familyId] ??
        {
          for (final m in marks)
            if (m.markedAt.isBefore(recent)) m.id!,
        };
    _announced[member.familyId] = marks.map((m) => m.id!).toSet();
    final fresh = marks.where((m) => !known.contains(m.id)).toList();
    for (final cardId in fresh.map((m) => m.cardId).toSet()) {
      await _afterMarks(session, cardId);
    }
    for (final m in fresh) {
      final question = await Question.db.findById(session, m.questionId);
      if (question == null) continue;
      await FamilyService.postEvent(
        session,
        member.familyId,
        kind: 'mark',
        message:
            '${m.parentName}: Q${question.position + 1} '
            '${_outcomeWords[m.outcome]}',
        actorName: m.parentName,
        cardId: m.cardId,
      );
    }
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
