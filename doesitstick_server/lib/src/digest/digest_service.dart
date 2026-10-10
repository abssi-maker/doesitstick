import 'package:serverpod/serverpod.dart';

import '../cards/card_service.dart';
import '../generated/protocol.dart';
import '../math/concepts.dart';

/// "What stuck": a concept only counts as stuck after a delayed re-check with
/// new numbers went well. Tonight's answers alone are never enough.
class DigestService {
  static const _solid = {Outcome.gotAnswer, Outcome.explainedWhy};
  static const _helped = {Outcome.notYet, Outcome.withHint};

  static Future<WeeklyDigest> weekly(
    Session session,
    int familyId, {
    DateTime? now,
  }) async {
    final end = (now ?? DateTime.now()).toUtc();
    final start = end.subtract(const Duration(days: 7));
    final family = await Family.db.findById(session, familyId);
    final cards = await QuestionCard.db.find(
      session,
      where: (t) =>
          t.familyId.equals(familyId) &
          (t.createdAt >= end.subtract(const Duration(days: 14))),
      orderBy: (t) => t.createdAt,
    );
    final rechecks = await Recheck.db.find(
      session,
      where: (t) =>
          t.familyId.equals(familyId) &
          t.status.equals(RecheckStatus.scheduled),
      orderBy: (t) => t.dueAt,
    );

    final concepts = <ConceptDigest>[];
    for (final concept in cards.map((c) => c.conceptId).toSet()) {
      final views = <CardView>[
        for (final c in cards.where((c) => c.conceptId == concept))
          await CardService.view(session, c),
      ];
      final evidence = <EvidenceItem>[
        for (final v in views)
          for (final q in v.questions)
            if (q.latest != null && !q.latest!.markedAt.isBefore(start))
              EvidenceItem(
                at: q.latest!.markedAt,
                recheckDay: v.card.recheckDay,
                style: q.question.style,
                outcome: q.latest!.outcome,
                parentName: q.latest!.parentName,
              ),
      ]..sort((a, b) => a.at.compareTo(b.at));
      if (evidence.isEmpty) continue;

      final next = rechecks.where((r) => r.conceptId == concept).firstOrNull;
      final status = _status(views);
      concepts.add(
        ConceptDigest(
          conceptId: concept,
          title: conceptInfos[concept]!.title,
          status: status.$1,
          reason: status.$2,
          evidence: evidence,
          nextRecheckAt: next?.dueAt,
        ),
      );
    }
    const order = {'growing': 0, 'waiting': 1, 'stuck': 2};
    concepts.sort((a, b) => order[a.status]!.compareTo(order[b.status]!));
    return WeeklyDigest(
      childName: family!.childName,
      weekStart: start,
      weekEnd: end,
      concepts: concepts,
      stuckCount: concepts.where((c) => c.status == 'stuck').length,
      growingCount: concepts.where((c) => c.status == 'growing').length,
    );
  }

  static (String, String) _status(List<CardView> views) {
    bool done(CardView v) => v.questions.every((q) => q.latest != null);
    final delayed = views.where((v) => v.card.recheckDay >= 2 && done(v));
    if (delayed.isNotEmpty) {
      final last = delayed.last;
      final day = last.card.recheckDay;
      final allSolid = last.questions.every(
        (q) => _solid.contains(q.latest!.outcome),
      );
      return allSolid
          ? ('stuck', 'Got it again on day $day, with new numbers.')
          : ('growing', 'Needed help on the day-$day re-check.');
    }
    final tonight = views.where((v) => v.card.recheckDay == 0 && done(v));
    if (tonight.isEmpty) return ('waiting', 'Started, not finished yet.');
    final last = tonight.last;
    final helped = last.questions
        .where((q) => _helped.contains(q.latest!.outcome))
        .length;
    final why = last.questions
        .where((q) => q.latest!.outcome == Outcome.explainedWhy)
        .length;
    if (helped > 0) {
      return (
        'growing',
        'Needed help on $helped of ${last.questions.length} tonight.',
      );
    }
    return (
      'waiting',
      'Explained $why of ${last.questions.length} tonight. '
          'The re-check will show if it stuck.',
    );
  }
}
