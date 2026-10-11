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
  final VoidCallback onTryItOut;
  const RechecksScreen({super.key, required this.onTryItOut});

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
        const ScreenHeader(
          eyebrow: 'Did it stick?',
          title: 'A quick check, days later',
        ),
        const SizedBox(height: 8),
        Text(
          'Memory fades fast. A quick check on day 2 and day 7, with new '
          'numbers, shows what really stuck. When one is due, it shows up on '
          'Tonight.',
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
                  child: const Text('Start re-check'),
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
        if (scheduled.isNotEmpty)
          TextButton(
            key: const Key('previewRechecks'),
            onPressed: onTryItOut,
            child: const Text('Don’t want to wait? Try it out in Family'),
          ),
      ],
    );
  }
}
