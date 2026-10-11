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
        ScreenHeader(eyebrow: 'Tonight', title: '$child’s homework, calmly'),
        const SizedBox(height: 16),
        const _LiveAtTable(),
        if (rechecks.isNotEmpty) ...[
          Panel(
            color: C.skyS,
            child: Row(
              children: [
                const Text('🔁', style: TextStyle(fontSize: 26)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    rechecks.length > 1
                        ? '${rechecks.length} quick re-checks, when you’re ready'
                        : 'A quick re-check, when you’re ready',
                    style: t.titleMedium!.copyWith(color: C.skyT),
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
          _Reading(child: child, photo: c.photoFor(ws.id))
        else if (ws != null && ws.status == WorksheetStatus.needsTopic)
          _NeedsTopic(worksheet: ws),
        if (card != null) ...[
          const SizedBox(height: 4),
          _CardSummary(
            card: card,
            worksheet: cardWorksheet,
            photo: c.photoFor(cardWorksheet?.id),
          ),
          const SizedBox(height: 18),
        ] else if (ws == null) ...[
          const Stick(
            says: 'Snap the worksheet. I’ll tell you what to say.',
            mood: '📸',
          ),
          const SizedBox(height: 14),
          const _HowItWorks(),
          const SizedBox(height: 18),
        ],
        if (c.busy) const LinearProgressIndicator(),
        const SizedBox(height: 8),
        FilledButton.icon(
          key: const Key('snapWorksheet'),
          onPressed: c.busy ? null : () => _snap(context, ImageSource.camera),
          icon: const Icon(Icons.photo_camera_rounded),
          label: Text(
            card == null ? 'Snap the worksheet' : 'Snap a new worksheet',
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: c.busy ? null : () => _snap(context, ImageSource.gallery),
          icon: const Icon(Icons.photo_library_rounded),
          label: const Text('Choose a photo instead'),
        ),
        const SizedBox(height: 4),
        TextButton(
          key: const Key('trySample'),
          onPressed: c.busy
              ? null
              : () async {
                  try {
                    await c.snapSample();
                  } catch (e) {
                    if (context.mounted) toast(context, errorText(e));
                  }
                },
          style: TextButton.styleFrom(foregroundColor: C.grapeT),
          child: const Text('No worksheet at hand? Try a sample one'),
        ),
        TextButton(
          key: const Key('pickTopic'),
          onPressed: c.busy ? null : () => showTopicSheet(context),
          style: TextButton.styleFrom(foregroundColor: C.ink2),
          child: const Text('No photo? Pick the topic yourself'),
        ),
        const SizedBox(height: 4),
        Text(
          home.aiReaderEnabled
              ? 'Google Gemini reads the photo. Only your family can see it, '
                    'and it’s deleted after 7 days.'
              : 'Photo reading is off here, so you’ll pick the topic after '
                    'the photo. It’s deleted after 7 days.',
          style: t.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// What the parent who's away sees while the other one sits with the
/// child: the problem they're on, live, and three cheers to send.
class _LiveAtTable extends StatelessWidget {
  const _LiveAtTable();

  static const _cheers = [
    (Cheer.proud, '💛', 'Proud of you'),
    (Cheer.thinking, '🧠', 'Great thinking'),
    (Cheer.keepGoing, '🙌', 'Keep going'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = FamilyScope.of(context);
    final p = c.partnerHere;
    final card = p?.cardId == null ? null : c.cardById(p!.cardId!);
    if (p == null || card == null || !p.atTable) {
      return const SizedBox.shrink();
    }
    final t = Theme.of(context).textTheme;
    final child = c.home!.family.childName;
    final step = (p.step ?? 0).clamp(0, card.questions.length - 1);
    final q = card.questions[step].question;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Panel(
        key: const Key('liveAtTable'),
        color: C.mintS,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '● Live now',
                    style: t.titleSmall!.copyWith(color: C.mintT),
                  ),
                ),
                Text(
                  'Problem ${step + 1} of ${card.questions.length}',
                  style: t.bodySmall!.copyWith(color: C.mintT),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('“${q.prompt}”', style: t.titleLarge),
            const SizedBox(height: 4),
            Text(
              p.detail == 'hint'
                  ? '💡 Working through it with a hint'
                  : '${p.name} and $child are on it',
              style: t.bodyMedium!.copyWith(color: C.mintT),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                for (var i = 0; i < card.questions.length; i++)
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 8,
                      margin: EdgeInsets.only(
                        right: i < card.questions.length - 1 ? 6 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: c.effectiveMark(card.questions[i]) != null
                            ? C.mint
                            : (i == step ? C.paper : C.line),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text('Send $child a cheer', style: t.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final (cheer, emoji, label) in _cheers) ...[
                  Expanded(
                    child: _CheerButton(
                      key: Key('cheer-${cheer.name}'),
                      emoji: emoji,
                      label: label,
                      onTap: () async {
                        try {
                          await c.sendCheer(cheer);
                          if (context.mounted) {
                            toast(context, 'Sent. ${p.name} will read it out.');
                          }
                        } catch (e) {
                          if (context.mounted) toast(context, errorText(e));
                        }
                      },
                    ),
                  ),
                  if (cheer != _cheers.last.$1) const SizedBox(width: 8),
                ],
              ],
            ),
            const SizedBox(height: 4),
            TextButton(
              key: const Key('followAlong'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FamilyScope(
                    controller: c,
                    child: CardScreen(cardId: card.card.id!, following: true),
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: C.mintT,
              ),
              child: const Text('Follow along ›'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheerButton extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;
  const _CheerButton({
    super.key,
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: C.paper,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(height: 4),
              // Two lines tall for every label, so the three line up.
              SizedBox(
                height: 36,
                child: Center(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                      color: C.ink,
                      fontSize: 13,
                      height: 1.25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Three steps, shown before the first worksheet so the promise is clear.
class _HowItWorks extends StatelessWidget {
  const _HowItWorks();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    Widget step(String icon, String title, String body) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: t.titleMedium),
                Text(body, style: t.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
    return Panel(
      child: Column(
        children: [
          step(
            '📸',
            'Snap tonight’s worksheet',
            'We read the problems and the topic.',
          ),
          step(
            '🗣️',
            'Get the words',
            'What to say, the way the class teaches it, and hints that never '
                'give the answer away.',
          ),
          step(
            '🔎',
            'Help for the wrong answer',
            'Type what they said. See the likely slip, what to ask next, and '
                'a kind way to stop.',
          ),
          step(
            '🔁',
            'See if it stuck',
            'A quick check on day 2 and day 7, with new numbers.',
          ),
        ],
      ),
    );
  }
}

/// The photo the parent just took, from this phone's memory only.
class _Photo extends StatelessWidget {
  final Uint8List bytes;
  final double height;
  const _Photo({required this.bytes, this.height = 160});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Image.memory(
        bytes,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      ),
    );
  }
}

/// The worksheet photo for either parent: a thumbnail that opens full screen.
class _WorksheetPhoto extends StatefulWidget {
  final Worksheet worksheet;
  final Uint8List? fresh;
  const _WorksheetPhoto({required this.worksheet, this.fresh});

  @override
  State<_WorksheetPhoto> createState() => _WorksheetPhotoState();
}

class _WorksheetPhotoState extends State<_WorksheetPhoto> {
  late Future<Uint8List?> _photo = _load();

  Future<Uint8List?> _load() async =>
      widget.fresh ??
      await FamilyScope.of(context)
          .loadPhoto(widget.worksheet)
          .catchError(
            (_) => null,
          );

  @override
  void didUpdateWidget(_WorksheetPhoto old) {
    super.didUpdateWidget(old);
    if (old.worksheet.id != widget.worksheet.id) _photo = _load();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _photo,
      builder: (context, snap) {
        final bytes = snap.data;
        if (bytes == null) return const SizedBox.shrink();
        return InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => FamilyScope(
                controller: FamilyScope.of(context),
                child: _PhotoViewer(worksheet: widget.worksheet, bytes: bytes),
              ),
            ),
          ),
          child: Stack(
            children: [
              _Photo(bytes: bytes, height: 120),
              const Positioned(
                left: 8,
                bottom: 8,
                child: Pill('🔒 Private · 7 days', bg: C.mintS, fg: C.mintT),
              ),
              const Positioned(
                right: 8,
                bottom: 8,
                child: Pill('Tap to see it all', bg: C.paper, fg: C.ink),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PhotoViewer extends StatelessWidget {
  final Worksheet worksheet;
  final Uint8List bytes;
  const _PhotoViewer({required this.worksheet, required this.bytes});

  @override
  Widget build(BuildContext context) {
    final c = FamilyScope.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: C.cream,
        title: const Text('Tonight’s worksheet'),
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              maxScale: 5,
              child: Center(child: Image.memory(bytes)),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Pinch to zoom. Only your family can see this photo; it’s '
                    'deleted automatically after 7 days.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    key: const Key('deletePhoto'),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete this photo now?'),
                          content: const Text(
                            'Tonight’s problems and answers stay. Only the '
                            'picture is deleted, for both of you.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Keep it'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (ok != true) return;
                      await c.deletePhoto(worksheet.id!);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: const Text('Delete photo now'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Reading extends StatelessWidget {
  final String child;
  final Uint8List? photo;
  const _Reading({required this.child, this.photo});

  @override
  Widget build(BuildContext context) {
    final photo = this.photo;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Panel(
        color: C.grapeS,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (photo != null) ...[
              _Photo(bytes: photo),
              const SizedBox(height: 14),
            ],
            Stick(says: 'Reading $child’s worksheet…', mood: '✦'),
            const SizedBox(height: 14),
            const LinearProgressIndicator(
              color: C.grape,
              backgroundColor: C.paper,
            ),
            const SizedBox(height: 8),
            Text(
              'Both phones get the coaching when it’s ready.',
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
  final Uint8List? photo;
  const _CardSummary({required this.card, this.worksheet, this.photo});

  @override
  Widget build(BuildContext context) {
    final c = FamilyScope.of(context);
    final t = Theme.of(context).textTheme;
    final marked = card.questions
        .where((q) => c.effectiveMark(q) != null)
        .length;
    final done = marked == card.questions.length;
    final problems = worksheet?.detectedProblems ?? const [];
    final fromSheet = card.questions
        .where((q) => q.question.fromWorksheet)
        .length;
    final photo = this.photo;
    final sheet = worksheet;
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sheet != null && sheet.photoDeletedAt == null) ...[
            _WorksheetPhoto(worksheet: sheet, fresh: photo),
            const SizedBox(height: 12),
          ],
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
            const SizedBox(height: 8),
            Text('Found on the worksheet', style: t.bodySmall),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final p in problems)
                  Pill(
                    p.replaceAll(RegExp(r'\s*=\s*_*$'), ''),
                    bg: C.skyS,
                    fg: C.skyT,
                  ),
              ],
            ),
            if (fromSheet > 0) ...[
              const SizedBox(height: 6),
              Text(
                '$fromSheet of tonight’s ${card.questions.length} problems '
                'come straight from it.',
                style: t.bodySmall,
              ),
            ],
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
                ? 'All done. We’ll check it stuck on day 2 and day 7.'
                : '$marked of ${card.questions.length} done',
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
            child: Text(
              done ? 'See tonight’s card' : 'Work through it together',
            ),
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
