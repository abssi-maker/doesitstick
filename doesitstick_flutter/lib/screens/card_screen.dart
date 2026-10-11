import 'package:doesitstick_client/doesitstick_client.dart';
import 'package:flutter/material.dart';

import '../state/family_controller.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../widgets/how_it_works.dart';
import 'home_shell.dart';
import 'tonight_screen.dart';

const _styleLabel = {
  QuestionStyle.solve: 'Answer it',
  QuestionStyle.explain: 'Explain it',
  QuestionStyle.catchMistake: 'Catch the mistake',
};

const _outcomes = [
  (Outcome.notYet, '🌱', 'Not yet'),
  (Outcome.withHint, '💡', 'With a hint'),
  (Outcome.gotAnswer, '✓', 'Got the answer'),
  (Outcome.explainedWhy, '★', 'Explained why'),
];

/// Coaching for the parent, one problem at a time (from the worksheet when
/// it was read): what to say, then "got it" (ask why) or "not quite" (what
/// did they say, step-by-step help, a kind ending). Opened by the parent
/// who isn't at the table, it [following]s along instead.
class CardScreen extends StatefulWidget {
  final int cardId;
  final bool following;
  const CardScreen({super.key, required this.cardId, this.following = false});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  /// One problem on screen at a time; [_finished] shows the summary.
  int _step = 0;
  bool _finished = false;
  bool _placed = false;
  bool _stuck = false;
  late final FamilyController _c = FamilyScope.of(context);

  /// Tells the other parent's phone where this one is.
  void _report() {
    _c.setPresence(
      cardId: widget.cardId,
      step: _step,
      detail: widget.following
          ? 'following'
          : _finished
          ? 'done'
          : _stuck
          ? 'hint'
          : 'working',
    );
  }

  @override
  void dispose() {
    _c.setPresence(detail: 'around');
    super.dispose();
  }

  Widget _donePanel(
    BuildContext context,
    bool isRecheck,
    List<Recheck> next,
  ) {
    final t = Theme.of(context).textTheme;
    return Panel(
      color: C.mintS,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isRecheck ? 'Re-check done 🎉' : 'Done, calmly 🎉',
            style: t.titleLarge!.copyWith(color: C.mintT),
          ),
          const SizedBox(height: 6),
          Text(
            next.isEmpty
                ? (isRecheck
                      ? 'This counts toward the weekly “what stuck”.'
                      : 'Setting up the re-checks…')
                : 'We’ll check it stuck on '
                      '${next.map((r) => '${shortDate(r.dueAt)} (day ${r.dayOffset})').join(' and ')}, '
                      'with new numbers. When it’s due, it shows up on Tonight.',
            style: t.bodyMedium!.copyWith(color: C.mintT),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = FamilyScope.of(context);
    final card = c.cardById(widget.cardId);
    final t = Theme.of(context).textTheme;
    if (card == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final marked = card.questions
        .where((q) => c.effectiveMark(q) != null)
        .length;
    final done = marked == card.questions.length;
    final isRecheck = card.card.kind == CardKind.recheck;
    final next = c.home!.rechecks
        .where(
          (r) =>
              r.sourceCardId == card.card.id &&
              r.status == RecheckStatus.scheduled,
        )
        .toList();
    if (!_placed) {
      // Open where the parent left off; a finished card opens on its summary.
      _placed = true;
      _finished = done;
      final open = card.questions.indexWhere((q) => c.effectiveMark(q) == null);
      _step = open < 0 ? 0 : open;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _report();
    });
    final worksheet = c.home!.worksheets
        .where((w) => w.cardId == card.card.id)
        .firstOrNull;
    final canChangeTopic =
        !isRecheck &&
        worksheet != null &&
        card.questions.every((q) => q.marks.isEmpty) &&
        c.outbox.every(
          (m) => card.questions.every((q) => q.question.id != m.questionId),
        );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: C.cream,
        surfaceTintColor: C.cream,
        title: Text(
          isRecheck
              ? 'Day ${card.card.recheckDay} · did it stick?'
              : 'Work through it together',
          style: t.titleMedium,
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 4, 22, 32),
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: TogetherChip(),
              ),
              const SizedBox(height: 8),
              Text(card.conceptTitle, style: t.headlineSmall),
              const SizedBox(height: 10),
              Panel(
                color: C.skyS,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How the class does it · ${card.methodName}',
                      style: t.bodySmall!.copyWith(
                        color: C.skyT,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      card.methodLine,
                      style: t.bodyMedium!.copyWith(color: C.skyT),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      key: const Key('doubleChecked'),
                      onTap: () => showHowItWorks(context),
                      child: Text(
                        '✓ Every answer double-checked  ›',
                        style: t.bodySmall!.copyWith(
                          color: C.mintT,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (isRecheck)
                const Stick(says: 'Same idea, brand-new numbers.', mood: '🔁')
              else if (card.questions.any((q) => q.question.fromWorksheet))
                Stick(
                  says:
                      'Straight from ${c.home!.family.childName}’s worksheet.',
                  mood: '📄',
                )
              else
                const Stick(says: 'Read each line aloud. Go slow.', mood: '🌿'),
              const SizedBox(height: 16),
              if (_finished) ...[
                if (done) _donePanel(context, isRecheck, next),
                const SizedBox(height: 14),
                for (var i = 0; i < card.questions.length; i++)
                  _SummaryRow(
                    index: i,
                    view: card.questions[i],
                    onTap: () => setState(() {
                      _step = i;
                      _finished = false;
                    }),
                  ),
              ] else ...[
                _Steps(
                  count: card.questions.length,
                  current: _step,
                  marked: [
                    for (final q in card.questions) c.effectiveMark(q) != null,
                  ],
                  onTap: (i) => setState(() {
                    _step = i;
                    _stuck = false;
                  }),
                ),
                const SizedBox(height: 12),
                _QuestionTile(
                  key: ValueKey(card.questions[_step].question.id),
                  index: _step,
                  view: card.questions[_step],
                  isRecheck: isRecheck,
                  onStuck: (stuck) => setState(() => _stuck = stuck),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    if (_step > 0)
                      TextButton.icon(
                        onPressed: () => setState(() {
                          _step--;
                          _stuck = false;
                        }),
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text('Back'),
                      ),
                    const Spacer(),
                    FilledButton(
                      key: const Key('nextProblem'),
                      onPressed: () => setState(() {
                        _stuck = false;
                        if (_step < card.questions.length - 1) {
                          _step++;
                        } else {
                          _finished = true;
                        }
                      }),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(160, 52),
                      ),
                      child: Text(
                        _step < card.questions.length - 1
                            ? 'Next problem'
                            : 'Finish',
                      ),
                    ),
                  ],
                ),
              ],
              if (canChangeTopic) ...[
                const SizedBox(height: 6),
                TextButton(
                  onPressed: () async {
                    await showTopicSheet(context, worksheetId: worksheet.id);
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  child: const Text('Not this topic?'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _QuestionTile extends StatefulWidget {
  final int index;
  final QuestionView view;
  final bool isRecheck;
  final ValueChanged<bool> onStuck;
  const _QuestionTile({
    super.key,
    required this.index,
    required this.view,
    required this.isRecheck,
    required this.onStuck,
  });

  @override
  State<_QuestionTile> createState() => _QuestionTileState();
}

/// Where the conversation about one problem is: just asked, they got it
/// (now ask why), or not quite (what did they say, then step-by-step help).
enum _Phase { ask, gotIt, stuck }

class _QuestionTileState extends State<_QuestionTile> {
  _Phase _phase = _Phase.ask;
  bool _editing = false;

  void _go(_Phase phase) {
    setState(() => _phase = phase);
    widget.onStuck(phase == _Phase.stuck);
  }

  Future<void> _mark(FamilyController c, Outcome outcome) async {
    await c.mark(widget.view.question, outcome);
    if (!mounted) return;
    setState(() => _editing = false);
    widget.onStuck(false);
  }

  String _syncWords(FamilyController c, EffectiveMark m) {
    final partner = c.partner;
    switch (m.sync) {
      case MarkSync.savedOnPhone:
        return 'Saved on this phone';
      case MarkSync.sending:
        return 'Sending…';
      case MarkSync.shared:
        if (m.by != c.me) return 'Marked by ${m.by}';
        return partner == null ? 'Saved' : 'Saved · $partner sees it too';
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = FamilyScope.of(context);
    final t = Theme.of(context).textTheme;
    final q = widget.view.question;
    final mark = c.effectiveMark(widget.view);
    final child = c.home!.family.childName;
    final open = mark == null || _editing;
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: mark != null ? C.mint : C.grapeS,
                child: Text(
                  '${widget.index + 1}',
                  style: TextStyle(
                    color: mark != null ? Colors.white : C.grapeT,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(_styleLabel[q.style]!, style: t.titleMedium),
              ),
              if (q.fromWorksheet)
                const Pill('📄 From the worksheet', bg: C.skyS, fg: C.skyT)
              else if (!widget.isRecheck)
                const Pill('New numbers', bg: C.grapeS, fg: C.grapeT),
            ],
          ),
          const SizedBox(height: 12),
          Text('Say:', style: t.bodySmall),
          Text('“${q.prompt}”', style: t.titleLarge!.copyWith(fontSize: 23)),
          const SizedBox(height: 12),
          _AnswerBox(answer: q.expectedAnswer),
          const SizedBox(height: 14),
          if (!open)
            _Result(
              mark: mark,
              syncWords: _syncWords(c, mark),
              onChange: () {
                setState(() {
                  _editing = true;
                  _phase = _Phase.ask;
                });
              },
            )
          else
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: switch (_phase) {
                _Phase.ask => _AskButtons(
                  child: child,
                  onGotIt: () => _go(_Phase.gotIt),
                  onStuck: () => _go(_Phase.stuck),
                ),
                _Phase.gotIt => _AskWhy(
                  question: q,
                  onMark: (o) => _mark(c, o),
                  onBack: () => _go(_Phase.ask),
                ),
                _Phase.stuck => _StuckHelp(
                  key: ValueKey('stuck-${q.id}'),
                  question: q,
                  child: child,
                  onRight: () => _go(_Phase.gotIt),
                  onMark: (o) => _mark(c, o),
                  onBack: () => _go(_Phase.ask),
                ),
              },
            ),
        ],
      ),
    );
  }
}

class _AnswerBox extends StatelessWidget {
  final String answer;
  const _AnswerBox({required this.answer});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: C.cream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.line, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Answer', style: t.bodySmall),
              const Spacer(),
              const Text(
                '👁 only you',
                style: TextStyle(fontSize: 12, color: C.ink2),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(answer, style: t.titleMedium),
        ],
      ),
    );
  }
}

/// The two things that can happen after asking.
class _AskButtons extends StatelessWidget {
  final String child;
  final VoidCallback onGotIt;
  final VoidCallback onStuck;
  const _AskButtons({
    required this.child,
    required this.onGotIt,
    required this.onStuck,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How did $child do?', style: t.bodySmall),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _BigChoice(
                key: const Key('gotIt'),
                icon: '✓',
                label: 'Got it',
                bg: C.mintS,
                fg: C.mintT,
                onTap: onGotIt,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _BigChoice(
                key: const Key('notQuite'),
                icon: '🤔',
                label: 'Not quite',
                bg: C.sunS,
                fg: C.sunT,
                onTap: onStuck,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BigChoice extends StatelessWidget {
  final String icon;
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;
  const _BigChoice({
    super.key,
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: SizedBox(
          height: 64,
          child: Center(
            child: Text(
              '$icon  $label',
              style: TextStyle(
                color: fg,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A right answer might be a guess: ask how they know, then note what you
/// heard.
class _AskWhy extends StatelessWidget {
  final Question question;
  final ValueChanged<Outcome> onMark;
  final VoidCallback onBack;
  const _AskWhy({
    required this.question,
    required this.onMark,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final q = question;
    final explainAlready = q.style == QuestionStyle.explain;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Coach(
          bg: C.mintS,
          fg: C.mintT,
          label: explainAlready ? '🎧 Listen for' : '🗣️ Now ask',
          text: explainAlready ? q.listenFor : '“How do you know?”',
        ),
        if (!explainAlready)
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 4),
            child: Text(
              'A good answer: ${q.listenFor}',
              style: t.bodySmall,
            ),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _OutcomeButton(
                key: Key('mark-${q.id}-explainedWhy'),
                label: '★ Explained why',
                outcome: Outcome.explainedWhy,
                onTap: () => onMark(Outcome.explainedWhy),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _OutcomeButton(
                key: Key('mark-${q.id}-gotAnswer'),
                label: '✓ Just the answer',
                outcome: Outcome.gotAnswer,
                onTap: () => onMark(Outcome.gotAnswer),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: onBack,
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: const Text('Back'),
        ),
      ],
    );
  }
}

/// The stuck moment, where the shouting usually starts. First: what did the
/// child say? A known slip gets its own question to ask; anything else gets
/// "how did you get that?". Then help one step at a time, never the answer,
/// ending kindly. Getting there with help is marked "With a hint" by itself.
class _StuckHelp extends StatefulWidget {
  final Question question;
  final String child;
  final VoidCallback onRight;
  final ValueChanged<Outcome> onMark;
  final VoidCallback onBack;
  const _StuckHelp({
    super.key,
    required this.question,
    required this.child,
    required this.onRight,
    required this.onMark,
    required this.onBack,
  });

  @override
  State<_StuckHelp> createState() => _StuckHelpState();
}

class _StuckHelpState extends State<_StuckHelp> {
  final _said = TextEditingController();
  int? _heard;
  bool _blank = false;

  /// 0: nothing yet; 1 nudge; 2 next step; 3 walk-through; 4 kind ending.
  int _rung = 0;

  List<(String, String)> get _rungs {
    final q = widget.question;
    final next = q.nextStep;
    return [
      ('💡 Nudge · read this aloud', '“${q.hint}”'),
      if (next != null && next.isNotEmpty)
        ('👣 Next step · do it together', next),
      ('🧭 Walk through it together', q.methodNote),
    ];
  }

  @override
  void dispose() {
    _said.dispose();
    super.dispose();
  }

  void _check() {
    final digits = RegExp(r'\d+').firstMatch(_said.text)?.group(0);
    if (digits == null) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _heard = int.parse(digits);
      _blank = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final q = widget.question;
    final heard = _heard;
    final right = heard != null && heard == q.answerValue;
    final slip = heard == null || right
        ? null
        : (q.slips ?? const <Slip>[])
              .where((s) => s.answer == heard)
              .firstOrNull;
    final rungs = _rungs;
    final ended = _rung > rungs.length;
    final helped = heard != null || _blank || _rung > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Take a breath. Stuck is where learning happens.',
          style: t.bodySmall!.copyWith(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 10),
        Text('What did ${widget.child} say?', style: t.titleSmall),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const Key('saidField'),
                controller: _said,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _check(),
                decoration: InputDecoration(
                  hintText: 'Their answer',
                  isDense: true,
                  filled: true,
                  fillColor: C.cream,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: C.line),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              key: const Key('checkSaid'),
              onPressed: _check,
              style: FilledButton.styleFrom(minimumSize: const Size(80, 48)),
              child: const Text('Check'),
            ),
          ],
        ),
        if (heard == null && !_blank)
          TextButton(
            key: const Key('saidNothing'),
            onPressed: () => setState(() {
              _blank = true;
              if (_rung == 0) _rung = 1;
            }),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: const Text('They don’t know where to start'),
          ),
        const SizedBox(height: 8),
        if (right) ...[
          _Coach(
            bg: C.mintS,
            fg: C.mintT,
            label: '🎉 That’s right!',
            text: 'Now find out if they know why.',
          ),
          const SizedBox(height: 8),
          FilledButton(
            key: const Key('rightAskWhy'),
            onPressed: widget.onRight,
            child: const Text('Ask how they know'),
          ),
        ] else if (slip != null)
          _Coach(
            bg: C.skyS,
            fg: C.skyT,
            label: '🔎 A common slip',
            text: slip.what,
            say: slip.ask,
          )
        else if (heard != null)
          const _Coach(
            bg: C.skyS,
            fg: C.skyT,
            label: '🔎 Not one of the usual slips',
            text: 'Often they spot it themselves when they talk it through.',
            say: 'How did you get that? Show me.',
          ),
        if (!right) ...[
          for (var i = 0; i < _rung && i < rungs.length; i++) ...[
            const SizedBox(height: 8),
            _Coach(
              bg: C.sunS,
              fg: C.sunT,
              label: rungs[i].$1,
              text: rungs[i].$2,
            ),
          ],
          if (ended) ...[
            const SizedBox(height: 8),
            const _Coach(
              bg: C.coralS,
              fg: C.coralT,
              label: '♡ Kind ending · say this, then stop',
              text: '',
              say: 'Great one to ask your teacher about tomorrow!',
            ),
          ],
          const SizedBox(height: 10),
          if (!ended) ...[
            if (helped) ...[
              _OutcomeButton(
                key: Key('mark-${q.id}-withHint'),
                label: '💡 Got it now',
                outcome: Outcome.withHint,
                onTap: () => widget.onMark(Outcome.withHint),
              ),
              const SizedBox(height: 8),
            ],
            OutlinedButton(
              key: const Key('nextHint'),
              onPressed: () {
                setState(() => _rung++);
                if (_rung > rungs.length) widget.onMark(Outcome.notYet);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                foregroundColor: C.sunT,
              ),
              child: Text(switch (_rung) {
                0 => 'Give a nudge',
                _ when _rung < rungs.length => 'Still stuck? Next step',
                _ => 'Still stuck? Stop for tonight',
              }),
            ),
          ],
          if (!ended)
            TextButton(
              onPressed: widget.onBack,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: const Text('Back'),
            ),
        ],
      ],
    );
  }
}

/// One coaching bubble: a label, what it means, and what to say.
class _Coach extends StatelessWidget {
  final Color bg;
  final Color fg;
  final String label;
  final String text;
  final String? say;
  const _Coach({
    required this.bg,
    required this.fg,
    required this.label,
    required this.text,
    this.say,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: t.bodySmall!.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (text.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(text, style: t.bodyMedium!.copyWith(color: fg)),
          ],
          if (say != null) ...[
            const SizedBox(height: 6),
            Text(
              'Ask: “$say”',
              style: t.titleSmall!.copyWith(color: fg, fontSize: 16),
            ),
          ],
        ],
      ),
    );
  }
}

/// What was noted for a problem, what to say about it, and who has it.
class _Result extends StatelessWidget {
  final EffectiveMark mark;
  final String syncWords;
  final VoidCallback onChange;
  const _Result({
    required this.mark,
    required this.syncWords,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final (icon, label) = _outcomes
        .where((o) => o.$1 == mark.outcome)
        .map((o) => (o.$2, o.$3))
        .first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Pill('$icon $label', bg: C.mintS, fg: C.mintT),
              ),
            ),
            TextButton(
              key: const Key('changeMark'),
              onPressed: onChange,
              child: const Text('Change'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        _Praise(outcome: mark.outcome),
        const SizedBox(height: 8),
        Text(
          syncWords,
          style: t.bodySmall!.copyWith(
            color: mark.sync == MarkSync.shared ? C.mintT : C.sunT,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// "Problem 2 of 3" with one dot per problem; marked ones fill in green.
class _Steps extends StatelessWidget {
  final int count;
  final int current;
  final List<bool> marked;
  final ValueChanged<int> onTap;
  const _Steps({
    required this.count,
    required this.current,
    required this.marked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      children: [
        Text('Problem ${current + 1} of $count', style: t.titleMedium),
        const Spacer(),
        for (var i = 0; i < count; i++)
          GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(left: 6),
              width: i == current ? 28 : 12,
              height: 12,
              decoration: BoxDecoration(
                color: marked[i] ? C.mint : (i == current ? C.grape : C.line),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
      ],
    );
  }
}

/// One line per problem on the finished card; tap to look again.
class _SummaryRow extends StatelessWidget {
  final int index;
  final QuestionView view;
  final VoidCallback onTap;
  const _SummaryRow({
    required this.index,
    required this.view,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = FamilyScope.of(context);
    final t = Theme.of(context).textTheme;
    final mark = c.effectiveMark(view);
    final label = mark == null
        ? 'Not marked'
        : _outcomes.firstWhere((o) => o.$1 == mark.outcome).$3;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: C.paper,
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onTap: onTap,
          title: Text(view.question.prompt, style: t.bodyMedium),
          subtitle: Text('${index + 1} · ${_styleLabel[view.question.style]}'),
          trailing: Pill(label),
        ),
      ),
    );
  }
}

/// What to say after the moment, praising the effort and the method rather
/// than the child, so even "not yet" ends warmly.
class _Praise extends StatelessWidget {
  final Outcome outcome;
  const _Praise({required this.outcome});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final words = switch (outcome) {
      Outcome.explainedWhy =>
        'You explained exactly why it works. That’s real understanding.',
      Outcome.gotAnswer => 'I like how you worked that out step by step.',
      Outcome.withHint => 'You stuck with it. That’s how you get better.',
      Outcome.notYet => 'Not yet is fine. We’ll try it again another day.',
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: C.mintS,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '♡ Say:',
            style: t.bodySmall!.copyWith(
              color: C.mintT,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text('“$words”', style: t.bodyMedium!.copyWith(color: C.mintT)),
        ],
      ),
    );
  }
}

class _OutcomeButton extends StatelessWidget {
  final String label;
  final Outcome outcome;
  final VoidCallback onTap;
  const _OutcomeButton({
    super.key,
    required this.label,
    required this.outcome,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (outcome) {
      Outcome.notYet => (C.coralS, C.coralT),
      Outcome.withHint => (C.sunS, C.sunT),
      Outcome.gotAnswer => (C.skyS, C.skyT),
      Outcome.explainedWhy => (C.mintS, C.mintT),
    };
    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: fg.withValues(alpha: 0.35), width: 2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: SizedBox(
          height: 52,
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
