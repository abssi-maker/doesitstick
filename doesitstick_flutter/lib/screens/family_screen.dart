import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:flutter/services.dart';

import '../client.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
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
                  'They sign in on their phone, tap “Join with code” and enter:',
                  style: t.bodySmall,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SelectableText(
                      f.inviteCode,
                      key: const Key('inviteCodeText'),
                      style: t.displaySmall!.copyWith(
                        letterSpacing: 4,
                        color: C.grapeT,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Copy code',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: f.inviteCode));
                        toast(context, 'Code copied');
                      },
                      icon: const Icon(Icons.copy_rounded),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Panel(
          color: C.sunS,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Demo: go offline',
                      style: t.titleMedium!.copyWith(color: C.sunT),
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
                'Marks are saved on this phone and sent when you come back '
                'online. Real network drops work the same way.',
                style: t.bodySmall!.copyWith(color: C.sunT),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
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
