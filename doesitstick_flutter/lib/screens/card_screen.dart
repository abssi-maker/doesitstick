import 'package:doesitstick_client/doesitstick_client.dart';
import 'package:flutter/material.dart';

import '../state/family_controller.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
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

/// Coaching for the parent: three problems (from the worksheet when it was
/// read), what to say, the class method, hints and a kind ending, then one
/// tap to note how it went.
class CardScreen extends StatefulWidget {
  final int cardId;
  const CardScreen({super.key, required this.cardId});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  /// One problem on screen at a time; [_finished] shows the summary.
  int _step = 0;
  bool _finished = false;
  bool _placed = false;

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
              const Align(alignment: Alignment.centerLeft, child: SyncChip()),
              const SizedBox(height: 12),
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
                  onTap: (i) => setState(() => _step = i),
                ),
                const SizedBox(height: 12),
                _QuestionTile(
                  key: ValueKey(card.questions[_step].question.id),
                  index: _step,
                  view: card.questions[_step],
                  isRecheck: isRecheck,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    if (_step > 0)
                      TextButton.icon(
                        onPressed: () => setState(() => _step--),
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text('Back'),
                      ),
                    const Spacer(),
                    FilledButton(
                      key: const Key('nextProblem'),
                      onPressed: () => setState(() {
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
  const _QuestionTile({
    super.key,
    required this.index,
    required this.view,
    required this.isRecheck,
  });

  @override
  State<_QuestionTile> createState() => _QuestionTileState();
}

class _QuestionTileState extends State<_QuestionTile> {
  bool _help = false;

  String _syncWords(FamilyController c, EffectiveMark m) {
    final partner = c.partner;
    switch (m.sync) {
      case MarkSync.savedOnPhone:
        return 'Saved on this phone';
      case MarkSync.sending:
        return 'Sending…';
      case MarkSync.shared:
        if (m.by != c.me) return 'Marked by ${m.by}';
        return partner == null ? 'Saved' : 'Saved · shared with $partner';
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = FamilyScope.of(context);
    final t = Theme.of(context).textTheme;
    final q = widget.view.question;
    final mark = c.effectiveMark(widget.view);
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
          Container(
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
                Text(q.expectedAnswer, style: t.titleMedium),
                if (q.checkedByCode) ...[
                  const SizedBox(height: 4),
                  const Text(
                    '✓ Answer checked by code',
                    style: TextStyle(
                      color: C.mintT,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 4),
          TextButton.icon(
            onPressed: () => setState(() => _help = !_help),
            icon: Icon(
              _help ? Icons.expand_less_rounded : Icons.expand_more_rounded,
            ),
            label: Text(_help ? 'Hide' : 'What a “why” sounds like'),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
          ),
          if (_help) ...[
            Text(
              'Listen for',
              style: t.bodySmall!.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(q.listenFor, style: t.bodyMedium),
            const SizedBox(height: 6),
            Text(q.methodNote, style: t.bodySmall),
            const SizedBox(height: 10),
          ],
          HintLadder(
            hint: q.hint,
            bigHint: q.methodNote,
            onKindExit: () => c.mark(q, Outcome.notYet),
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 4),
          Text('What did you hear?', style: t.bodySmall),
          const SizedBox(height: 6),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3.3,
            children: [
              for (final (o, icon, label) in _outcomes)
                _OutcomeButton(
                  key: Key('mark-${q.id}-${o.name}'),
                  icon: icon,
                  label: label,
                  outcome: o,
                  selected: mark?.outcome == o,
                  onTap: () => c.mark(q, o),
                ),
            ],
          ),
          if (mark != null) ...[
            const SizedBox(height: 10),
            _Praise(outcome: mark.outcome),
            const SizedBox(height: 8),
            Text(
              _syncWords(c, mark),
              style: t.bodySmall!.copyWith(
                color: mark.sync == MarkSync.shared ? C.mintT : C.sunT,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
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
  final String icon;
  final String label;
  final Outcome outcome;
  final bool selected;
  final VoidCallback onTap;
  const _OutcomeButton({
    super.key,
    required this.icon,
    required this.label,
    required this.outcome,
    required this.selected,
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
    return AnimatedScale(
      scale: selected ? 1.0 : 0.97,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      child: Material(
        color: selected ? bg : C.paper,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: selected ? fg : C.line, width: 2),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Center(
            child: Text(
              '$icon  $label',
              style: TextStyle(
                color: selected ? fg : C.ink,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One rung at a time, ending with a kind exit, so a stuck moment never
/// turns into a confrontation. Using a hint means success gets marked
/// "With a hint", kept apart from independent success.
class HintLadder extends StatefulWidget {
  final String hint;
  final String bigHint;
  final VoidCallback onKindExit;
  const HintLadder({
    super.key,
    required this.hint,
    required this.bigHint,
    required this.onKindExit,
  });

  @override
  State<HintLadder> createState() => _HintLadderState();
}

class _HintLadderState extends State<HintLadder> {
  int _rung = 0;

  Widget _rungBox(String label, String text) {
    final t = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: C.sunS,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: t.bodySmall!.copyWith(
              color: C.sunT,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(text, style: t.bodyMedium!.copyWith(color: C.sunT)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_rung >= 1)
          _rungBox('💡 Hint · read this aloud', '“${widget.hint}”'),
        if (_rung >= 2)
          _rungBox('Bigger hint · walk through it together', widget.bigHint),
        if (_rung >= 3)
          _rungBox(
            '♡ Kind ending · say this, then stop',
            '“Great one to ask your teacher about tomorrow!”',
          ),
        if (_rung >= 1 && _rung < 3)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              'If they get it now, mark “With a hint”.',
              style: t.bodySmall!.copyWith(color: C.sunT),
            ),
          ),
        if (_rung < 3)
          TextButton(
            key: const Key('nextHint'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: C.sunT,
            ),
            onPressed: () {
              setState(() => _rung++);
              if (_rung == 3) widget.onKindExit();
            },
            child: Text(switch (_rung) {
              0 => '🌱 Stuck? Give a hint',
              1 => 'Still stuck? Bigger hint',
              _ => 'Still stuck? Kind ending',
            }),
          ),
      ],
    );
  }
}
