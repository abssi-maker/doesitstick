import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:flutter/services.dart';

import '../client.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../widgets/how_it_works.dart';
import '../widgets/invite.dart';
import 'home_shell.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = FamilyScope.of(context);
    final t = Theme.of(context).textTheme;
    final f = c.home!.family;
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
      children: [
        ScreenHeader(eyebrow: 'Family', title: '${f.childName}’s grown-ups'),
        const SizedBox(height: 16),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final p in f.parents)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: p == f.me ? C.grapeS : C.mintS,
                        child: Text(
                          p.characters.first,
                          style: TextStyle(
                            color: p == f.me ? C.grapeT : C.mintT,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(p == f.me ? '$p (you)' : p, style: t.titleMedium),
                    ],
                  ),
                ),
              if (f.parents.length < 2) ...[
                const SizedBox(height: 8),
                Text('Invite your partner', style: t.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'Send them a link by WhatsApp, text or email. They’ll see '
                  'every problem and answer live, on their phone or computer.',
                  style: t.bodySmall,
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  key: const Key('sendInvite'),
                  onPressed: () => sendInvite(
                    context,
                    childName: f.childName,
                    code: f.inviteCode,
                  ),
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('Send an invite'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Or they choose “I was invited” and type this code:',
                        style: t.bodySmall,
                      ),
                    ),
                    SelectableText(
                      f.inviteCode,
                      key: const Key('inviteCodeText'),
                      style: t.titleLarge!.copyWith(
                        letterSpacing: 3,
                        color: C.grapeT,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Copy code',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: f.inviteCode));
                        toast(context, 'Code copied');
                      },
                      icon: const Icon(Icons.copy_rounded, size: 20),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _TryItOut(),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          key: const Key('howItWorks'),
          onPressed: () => showHowItWorks(context),
          icon: const Icon(Icons.info_outline_rounded),
          label: const Text('How Did It Stick works'),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () async {
            if (await confirmSignOut(context)) {
              await client.auth.signOutDevice();
            }
          },
          child: const Text('Sign out'),
        ),
      ],
    );
  }
}

/// See the parts of the app that normally take days or a bad connection,
/// right now.
class _TryItOut extends StatelessWidget {
  const _TryItOut();

  @override
  Widget build(BuildContext context) {
    final c = FamilyScope.of(context);
    final t = Theme.of(context).textTheme;
    return Panel(
      key: const Key('tryItOut'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Try it out', style: t.titleMedium),
          const SizedBox(height: 12),
          Text('See the re-checks now', style: t.titleSmall),
          const SizedBox(height: 2),
          Text(
            'Re-checks come back on day 2 and day 7. Skip ahead to see them '
            'today.',
            style: t.bodySmall,
          ),
          const SizedBox(height: 8),
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
                              if (context.mounted) {
                                toast(
                                  context,
                                  made == 0
                                      ? 'Nothing due yet. Finish tonight’s '
                                            'card first.'
                                      : '$made re-check${made > 1 ? 's' : ''} '
                                            'ready in “Did it stick?”',
                                );
                              }
                            } catch (e) {
                              if (context.mounted) toast(context, errorText(e));
                            }
                          },
                    child: Text('Day $days'),
                  ),
                ),
                if (days == 2) const SizedBox(width: 10),
              ],
            ],
          ),
          const Divider(height: 28, color: C.line),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Try it with no connection',
                  style: t.titleSmall,
                ),
              ),
              Switch(
                key: const Key('demoOffline'),
                value: c.demoOffline,
                onChanged: c.setDemoOffline,
              ),
            ],
          ),
          Text(
            'Marks save on this phone and sync when you switch back, the same '
            'as when the Wi-Fi really drops.',
            style: t.bodySmall,
          ),
        ],
      ),
    );
  }
}
