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
            '♡',
            'Know when to stop',
            'A kind way to end when it isn’t clicking tonight.',
          ),
          step(
            '🔁',
            'See if it stuck',
            'A 1-minute check on day 2 and day 7, with new numbers.',
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
                : '$marked of ${card.questions.length} done · a few calm minutes',
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
