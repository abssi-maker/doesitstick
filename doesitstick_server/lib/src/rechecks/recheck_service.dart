import 'package:serverpod/serverpod.dart';

import '../cards/card_service.dart';
import '../family/family_service.dart';
import '../generated/future_calls.dart';
import '../generated/protocol.dart';
import '../math/concepts.dart';

/// Re-checks 2 and 7 days after tonight's card. The [Recheck] row is the
/// source of truth; the future call only says "look at this row now", so a
/// duplicate or late call is harmless.
class RecheckService {
  static bool isShaky(Mark? latest) =>
      latest == null || latest.outcome != Outcome.explainedWhy;

  static String futureCallId(int recheckId) => 'recheck-$recheckId';

  /// Day 2 when anything was shaky; day 7 always, because "explained it
  /// tonight" is not the same as "still knows it next week".
  static Future<List<Recheck>> ensureScheduled(
    Session session,
    QuestionCard card,
  ) async {
    final view = await CardService.view(session, card);
    final shaky = view.questions.any((q) => isShaky(q.latest));
    final start = card.completedAt ?? DateTime.now().toUtc();
    final created = <Recheck>[];
    for (final day in shaky ? const [2, 7] : const [7]) {
      final existing = await Recheck.db.findFirstRow(
        session,
        where: (t) => t.sourceCardId.equals(card.id!) & t.dayOffset.equals(day),
      );
      if (existing != null) continue;
      final recheck = await Recheck.db.insertRow(
        session,
        Recheck(
          familyId: card.familyId,
          sourceCardId: card.id!,
          conceptId: card.conceptId,
          dayOffset: day,
          dueAt: start.add(Duration(days: day)),
          status: RecheckStatus.scheduled,
        ),
      );
      await session.serverpod.futureCalls
          .callAtTime(recheck.dueAt, identifier: futureCallId(recheck.id!))
          .recheck
          .materialize(recheck.id!);
      created.add(recheck);
    }
    return created;
  }

  /// Turns a due re-check into a card with new numbers. Safe to call twice.
  static Future<QuestionCard?> materialize(
    Session session,
    int recheckId, {
    bool fastForwarded = false,
  }) async {
    final claimed = await session.db.transaction((tx) async {
      final r = await Recheck.db.findById(
        session,
        recheckId,
        transaction: tx,
        lockMode: LockMode.forUpdate,
      );
      if (r == null || r.status != RecheckStatus.scheduled) return null;
      return Recheck.db.updateRow(
        session,
        r.copyWith(
          status: RecheckStatus.ready,
          fastForwarded: r.fastForwarded || fastForwarded,
        ),
        transaction: tx,
      );
    });
    if (claimed == null) return null;

    final source = await QuestionCard.db.findById(
      session,
      claimed.sourceCardId,
    );
    if (source == null) {
      await Recheck.db.updateRow(
        session,
        claimed.copyWith(status: RecheckStatus.skipped),
      );
      return null;
    }
    final view = await CardService.view(session, source);
    var picks = view.questions
        .where((q) => isShaky(q.latest))
        .map((q) => q.question)
        .toList();
    if (picks.isEmpty && claimed.dayOffset >= 7) {
      // Nothing was shaky: one "does it still stick" explain question.
      picks = view.questions
          .map((q) => q.question)
          .where((q) => q.style == QuestionStyle.explain)
          .take(1)
          .toList();
    }
    if (picks.isEmpty) {
      await Recheck.db.updateRow(
        session,
        claimed.copyWith(status: RecheckStatus.skipped),
      );
      return null;
    }

    final QuestionCard card;
    try {
      card = await CardService.createRecheckCard(
        session,
        source: source,
        sourceQuestions: picks,
        day: claimed.dayOffset,
      );
    } catch (e, st) {
      session.log(
        'Re-check $recheckId failed, retrying in 10 minutes',
        level: LogLevel.error,
        exception: e,
        stackTrace: st,
      );
      await Recheck.db.updateRow(
        session,
        claimed.copyWith(status: RecheckStatus.scheduled),
      );
      await session.serverpod.futureCalls
          .callWithDelay(
            const Duration(minutes: 10),
            identifier: futureCallId(recheckId),
          )
          .recheck
          .materialize(recheckId);
      return null;
    }
    await Recheck.db.updateRow(session, claimed.copyWith(cardId: card.id));
    await FamilyService.postEvent(
      session,
      claimed.familyId,
      kind: 'recheck',
      message:
          'Day-${claimed.dayOffset} re-check is ready: '
          '${conceptInfos[claimed.conceptId]!.title}',
      cardId: card.id,
    );
    return card;
  }

  /// Demo control: makes re-checks due within [days] happen now. They are
  /// flagged as fast-forwarded so nobody mistakes them for real elapsed time.
  static Future<int> jumpAhead(Session session, int familyId, int days) async {
    final horizon = DateTime.now().toUtc().add(Duration(days: days));
    final due = await Recheck.db.find(
      session,
      where: (t) =>
          t.familyId.equals(familyId) &
          t.status.equals(RecheckStatus.scheduled) &
          (t.dueAt <= horizon),
      orderBy: (t) => t.dueAt,
    );
    var made = 0;
    for (final r in due) {
      final card = await materialize(session, r.id!, fastForwarded: true);
      await session.serverpod.futureCalls.cancel(futureCallId(r.id!));
      if (card != null) made++;
    }
    return made;
  }
}
