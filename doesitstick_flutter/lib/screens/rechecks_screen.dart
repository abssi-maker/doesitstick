import 'package:doesitstick_client/doesitstick_client.dart';
import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../widgets/common.dart';
import 'card_screen.dart';
import 'home_shell.dart';

const _conceptTitles = {
  ConceptId.addRegroup: '3-digit addition',
  ConceptId.subtractCountUp: '3-digit subtraction',
  ConceptId.multiply2x1: '2-digit × 1-digit',
  ConceptId.multiply2x2: '2-digit × 2-digit',
  ConceptId.divideByOneDigit: 'Dividing by 1 digit',
  ConceptId.equivalentFractions: 'Equivalent fractions',
};

class RechecksScreen extends StatelessWidget {
  const RechecksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = FamilyScope.of(context);
    final t = Theme.of(context).textTheme;
    final ready = c.openRechecks;
    final scheduled = c.home!.rechecks
        .where((r) => r.status == RecheckStatus.scheduled)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
      children: [
        const ScreenHeader(eyebrow: 'Re-checks', title: 'Did it stick?'),
        const SizedBox(height: 8),
        Text(
          'Memory fades fast. A 1-minute check on day 2 and day 7, with new '
          'numbers, shows what really stuck.',
          style: t.bodyMedium!.copyWith(color: C.ink2),
        ),
        const SizedBox(height: 16),
        if (ready.isEmpty && scheduled.isEmpty)
          const Stick(says: 'Finish tonight’s card to set these.', mood: '😴'),
        for (final card in ready) ...[
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Pill('Day ${card.card.recheckDay}', bg: C.sunS, fg: C.sunT),
                    const SizedBox(width: 8),
                    Pill(
                      '${card.questions.length} question${card.questions.length > 1 ? 's' : ''}',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(card.conceptTitle, style: t.titleLarge),
                const SizedBox(height: 12),
                FilledButton(
                  key: Key('startRecheck-${card.card.id}'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FamilyScope(
                        controller: c,
                        child: CardScreen(cardId: card.card.id!),
                      ),
                    ),
                  ),
                  child: const Text('Start re-check · 1 min'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (scheduled.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text('Coming up', style: t.titleMedium),
          const SizedBox(height: 8),
          for (final r in scheduled)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Panel(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Pill('Day ${r.dayOffset}', bg: C.skyS, fg: C.skyT),
                    const SizedBox(width: 10),
                    Expanded(child: Text(_conceptTitles[r.conceptId]!)),
                    Text(
                      '${shortDate(r.dueAt)}, ${clock(r.dueAt)}',
                      style: t.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
        ],
        const SizedBox(height: 20),
        Panel(
          color: C.grapeS,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'For judges: jump ahead in time',
                style: t.titleMedium!.copyWith(color: C.grapeT),
              ),
              const SizedBox(height: 4),
              Text(
                'No need to wait a week. Runs the re-checks due in the next '
                'days right now (marked as fast-forwarded on the server).',
                style: t.bodySmall!.copyWith(color: C.grapeT),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (final days in const [2, 7]) ...[
                    Expanded(
                      child: OutlinedButton(
                        key: Key('jump-$days'),
                        onPressed: c.busy
                            ? null
                            : () async {
                                try {
                                  final made = await c.jumpAhead(days);
                                  if (context.mounted && made > 0) {
                                    toast(
                                      context,
                                      '$made re-check${made > 1 ? 's' : ''} ready',
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    toast(context, errorText(e));
                                  }
                                }
                              },
                        child: Text('Jump +$days days'),
                      ),
                    ),
                    if (days == 2) const SizedBox(width: 10),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
