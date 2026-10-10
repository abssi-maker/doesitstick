import 'package:doesitstick_client/doesitstick_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../client.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import 'home_shell.dart';

const _outcomeText = {
  Outcome.notYet: '🌱 not yet',
  Outcome.withHint: '💡 with a hint',
  Outcome.gotAnswer: '✓ got the answer',
  Outcome.explainedWhy: '★ explained why',
};

/// Weekly "what stuck". A concept is only "stuck" after a delayed re-check
/// with new numbers went well; that rule lives on the server.
class DigestScreen extends StatefulWidget {
  const DigestScreen({super.key});

  @override
  State<DigestScreen> createState() => _DigestScreenState();
}

class _DigestScreenState extends State<DigestScreen> {
  WeeklyDigest? _digest;
  HomeState? _seen;
  bool _sharing = false;

  Future<void> _load() async {
    try {
      final d = await client.progress.digest();
      if (mounted) setState(() => _digest = d);
    } catch (_) {}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final home = FamilyScope.of(context).home;
    if (!identical(home, _seen)) {
      _seen = home;
      _load();
    }
  }

  Future<void> _share(bool on) async {
    setState(() => _sharing = true);
    try {
      if (on) {
        final link = await client.progress.shareDigest();
        if (link.url != null) {
          await Clipboard.setData(ClipboardData(text: link.url!));
          if (mounted) toast(context, 'Link copied');
        }
      } else {
        await client.progress.stopSharing();
        if (mounted) toast(context, 'Sharing turned off');
      }
      if (mounted) await FamilyScope.of(context).refresh();
    } catch (e) {
      if (mounted) toast(context, errorText(e));
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = FamilyScope.of(context);
    final t = Theme.of(context).textTheme;
    final d = _digest;
    final shareUrl = c.home!.family.shareUrl;
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
        children: [
          ScreenHeader(
            eyebrow: d == null
                ? 'This week'
                : '${months[d.weekStart.toLocal().month - 1]} ${d.weekStart.toLocal().day} – '
                      '${months[d.weekEnd.toLocal().month - 1]} ${d.weekEnd.toLocal().day}',
            title: 'What stuck for ${c.home!.family.childName}',
          ),
          const SizedBox(height: 16),
          if (d == null)
            const Center(child: CircularProgressIndicator())
          else if (d.concepts.isEmpty)
            const Stick(
              says: 'Ask tonight’s card to start the week.',
              mood: '🪴',
            )
          else ...[
            Panel(
              child: Row(
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: d.concepts.isEmpty
                              ? 0
                              : d.stuckCount / d.concepts.length,
                          strokeWidth: 8,
                          color: C.mint,
                          backgroundColor: C.line,
                        ),
                        Text(
                          '${d.stuckCount}/${d.concepts.length}',
                          style: t.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      '${d.stuckCount} stuck · ${d.growingCount} still growing',
                      style: t.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            for (final concept in d.concepts) ...[
              _ConceptTile(concept: concept),
              const SizedBox(height: 12),
            ],
            Text(
              '“Stuck” means it held up on a re-check days later with new '
              'numbers. Three questions are a signal, not a grade.',
              style: t.bodySmall,
            ),
          ],
          const SizedBox(height: 20),
          Panel(
            color: C.grapeS,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share with a teacher or grandparent',
                  style: t.titleMedium!.copyWith(color: C.grapeT),
                ),
                const SizedBox(height: 4),
                Text(
                  'For a teacher or grandparent. Shows first name and concepts '
                  'only, no photos. You can turn it off any time.',
                  style: t.bodySmall!.copyWith(color: C.grapeT),
                ),
                const SizedBox(height: 10),
                if (shareUrl != null) ...[
                  SelectableText(shareUrl, style: t.bodyMedium),
                  const SizedBox(height: 10),
                ],
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        key: const Key('shareDigest'),
                        onPressed: _sharing ? null : () => _share(true),
                        child: Text(
                          shareUrl == null ? 'Create link' : 'Copy link',
                        ),
                      ),
                    ),
                    if (shareUrl != null) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _sharing ? null : () => _share(false),
                          child: const Text('Turn off'),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConceptTile extends StatelessWidget {
  final ConceptDigest concept;
  const _ConceptTile({required this.concept});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final (label, bg, fg) = switch (concept.status) {
      'stuck' => ('🌼 Stuck', C.mintS, C.mintT),
      'growing' => ('🌱 Still growing', C.sunS, C.sunT),
      _ => ('⏳ Waiting for re-check', C.skyS, C.skyT),
    };
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(concept.title, style: t.titleMedium)),
              Pill(label, bg: bg, fg: fg),
            ],
          ),
          const SizedBox(height: 6),
          Text(concept.reason, style: t.bodyMedium),
          const SizedBox(height: 8),
          for (final e in concept.evidence)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                '${shortDate(e.at)} · ${e.recheckDay == 0 ? 'Tonight' : 'Day ${e.recheckDay}'} · '
                '${_outcomeText[e.outcome]} · ${e.parentName}',
                style: t.bodySmall,
              ),
            ),
          if (concept.nextRecheckAt != null) ...[
            const SizedBox(height: 8),
            Text(
              'Next re-check: ${shortDate(concept.nextRecheckAt!)}',
              style: t.bodySmall!.copyWith(
                color: C.grapeT,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
