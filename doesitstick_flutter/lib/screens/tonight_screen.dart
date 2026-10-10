import 'package:doesitstick_client/doesitstick_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/tokens.dart';
import '../widgets/common.dart';
import 'card_screen.dart';
import 'home_shell.dart';

class TonightScreen extends StatelessWidget {
  final VoidCallback onOpenRechecks;
  const TonightScreen({super.key, required this.onOpenRechecks});

  Future<void> _snap(BuildContext context, ImageSource source) async {
    final c = FamilyScope.of(context);
    try {
      await c.snapWorksheet(source);
    } catch (e) {
      if (context.mounted) {
        toast(context, 'Upload didn’t work. ${errorText(e)}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = FamilyScope.of(context);
    final home = c.home!;
    final t = Theme.of(context).textTheme;
    final child = home.family.childName;
    final ws = c.activeWorksheet;
    final card = c.tonightCard;
    final cardWorksheet = card == null
        ? null
        : home.worksheets.where((w) => w.cardId == card.card.id).firstOrNull;
    final rechecks = c.openRechecks;

    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
      children: [
        ScreenHeader(eyebrow: 'Tonight', title: 'How did $child’s math go?'),
        const SizedBox(height: 16),
        if (rechecks.isNotEmpty) ...[
          Panel(
            color: C.sunS,
            child: Row(
              children: [
                const Text('⏰', style: TextStyle(fontSize: 26)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${rechecks.length} re-check${rechecks.length > 1 ? 's' : ''} '
                    'ready · about 1 min',
                    style: t.titleMedium!.copyWith(color: C.sunT),
                  ),
                ),
                TextButton(
                  onPressed: onOpenRechecks,
                  child: const Text('Start'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
        if (ws != null &&
            (ws.status == WorksheetStatus.reading ||
                ws.status == WorksheetStatus.uploaded))
          _Reading(child: child)
        else if (ws != null && ws.status == WorksheetStatus.needsTopic)
          _NeedsTopic(worksheet: ws),
        if (card != null) ...[
          const SizedBox(height: 4),
          _CardSummary(card: card, worksheet: cardWorksheet),
          const SizedBox(height: 18),
        ] else if (ws == null) ...[
          const Stick(says: 'Snap tonight’s worksheet to begin.', mood: '📸'),
          const SizedBox(height: 18),
        ],
        if (c.busy) const LinearProgressIndicator(),
        const SizedBox(height: 8),
        FilledButton.icon(
          key: const Key('snapWorksheet'),
          onPressed: c.busy ? null : () => _snap(context, ImageSource.camera),
          icon: const Icon(Icons.photo_camera_rounded),
          label: Text(
            card == null ? 'Photograph worksheet' : 'Snap a new worksheet',
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: c.busy
                    ? null
                    : () => _snap(context, ImageSource.gallery),
                child: const Text('Choose a photo'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                key: const Key('pickTopic'),
                onPressed: c.busy ? null : () => showTopicSheet(context),
                child: const Text('Pick the topic'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          home.aiReaderEnabled
              ? 'The photo is read once, then deleted.'
              : 'Photo reading is off on this server, so you’ll pick the '
                    'topic after the photo. The photo is still deleted.',
          style: t.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _Reading extends StatelessWidget {
  final String child;
  const _Reading({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Panel(
        color: C.grapeS,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stick(says: 'Reading $child’s worksheet…', mood: '✦'),
            const SizedBox(height: 14),
            const LinearProgressIndicator(
              color: C.grape,
              backgroundColor: C.paper,
            ),
            const SizedBox(height: 8),
            Text(
              'Both phones get the questions when it’s ready.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _NeedsTopic extends StatelessWidget {
  final Worksheet worksheet;
  const _NeedsTopic({required this.worksheet});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final problems = worksheet.detectedProblems ?? const [];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Which topic was it?', style: t.titleLarge),
            const SizedBox(height: 6),
            Text(
              worksheet.note ?? '',
              style: t.bodyMedium!.copyWith(color: C.ink2),
            ),
            if (problems.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final p in problems) Pill(p, bg: C.skyS, fg: C.skyT),
                ],
              ),
            ],
            const SizedBox(height: 14),
            FilledButton(
              onPressed: () =>
                  showTopicSheet(context, worksheetId: worksheet.id),
              child: const Text('Pick the topic'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardSummary extends StatelessWidget {
  final CardView card;
  final Worksheet? worksheet;
  const _CardSummary({required this.card, this.worksheet});

  @override
  Widget build(BuildContext context) {
    final c = FamilyScope.of(context);
    final t = Theme.of(context).textTheme;
    final marked = card.questions
        .where((q) => c.effectiveMark(q) != null)
        .length;
    final done = marked == card.questions.length;
    final problems = worksheet?.detectedProblems ?? const [];
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Pill('Grade ${card.grade} · ${card.methodName}'),
              const Spacer(),
              if (worksheet?.photoDeletedAt != null)
                const Pill('🔒 Photo deleted', bg: C.mintS, fg: C.mintT),
            ],
          ),
          const SizedBox(height: 12),
          Text(card.conceptTitle, style: t.titleLarge),
          if (problems.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Seen on the worksheet: ${problems.join(' · ')}',
              style: t.bodySmall,
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              for (var i = 0; i < card.questions.length; i++)
                Expanded(
                  child: Container(
                    height: 8,
                    margin: EdgeInsets.only(
                      right: i < card.questions.length - 1 ? 6 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: c.effectiveMark(card.questions[i]) != null
                          ? C.mint
                          : C.line,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            done
                ? 'All 3 asked. Re-checks are scheduled.'
                : '$marked of ${card.questions.length} asked · about 2 minutes',
            style: t.bodySmall,
          ),
          const SizedBox(height: 14),
          FilledButton(
            key: const Key('openCard'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FamilyScope(
                  controller: c,
                  child: CardScreen(cardId: card.card.id!),
                ),
              ),
            ),
            style: done
                ? FilledButton.styleFrom(backgroundColor: C.mintD)
                : null,
            child: Text(done ? 'See tonight’s card' : 'Ask the 3 questions'),
          ),
        ],
      ),
    );
  }
}

Future<void> showTopicSheet(BuildContext context, {int? worksheetId}) async {
  final c = FamilyScope.of(context);
  final concept = await showModalBottomSheet<ConceptId>(
    context: context,
    backgroundColor: C.cream,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
    ),
    builder: (context) {
      final t = Theme.of(context).textTheme;
      return SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
          children: [
            Text('What was tonight’s homework?', style: t.titleLarge),
            const SizedBox(height: 12),
            for (final o in c.concepts)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: C.paper,
                  borderRadius: BorderRadius.circular(20),
                  child: ListTile(
                    key: Key('topic-${o.conceptId.name}'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(o.title, style: t.titleMedium),
                    subtitle: Text(
                      'Grade ${o.grade} · ${o.methodName} · e.g. ${o.example}',
                    ),
                    onTap: () => Navigator.pop(context, o.conceptId),
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
  if (concept == null) return;
  try {
    await c.chooseTopic(concept, worksheetId: worksheetId);
  } catch (e) {
    if (context.mounted) toast(context, errorText(e));
    if (kDebugMode) debugPrint('$e');
  }
}
