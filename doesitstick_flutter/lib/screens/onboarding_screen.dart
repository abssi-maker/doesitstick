import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

/// Pairs this parent into a family: start one, or join with a partner's code.
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onDone;
  const OnboardingScreen({super.key, required this.onDone});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _joining = false;
  bool _busy = false;
  final _child = TextEditingController();
  final _code = TextEditingController();
  final _name = TextEditingController();

  Future<void> _submit() async {
    setState(() => _busy = true);
    try {
      if (_joining) {
        await client.family.join(_code.text, _name.text);
      } else {
        await client.family.create(_child.text, _name.text);
      }
      widget.onDone();
    } catch (e) {
      if (mounted) toast(context, errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: ListView(
              padding: const EdgeInsets.all(22),
              children: [
                const SizedBox(height: 16),
                const Eyebrow('Set up'),
                const SizedBox(height: 6),
                Text(
                  _joining ? 'Join your partner' : 'Who are we checking on?',
                  style: t.displaySmall,
                ),
                const SizedBox(height: 16),
                Stick(
                  says: _joining
                      ? 'Your partner’s code is on their Family tab.'
                      : 'Your child needs no account or phone.',
                ),
                const SizedBox(height: 20),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('Start a family')),
                    ButtonSegment(value: true, label: Text('Join with code')),
                  ],
                  selected: {_joining},
                  onSelectionChanged: (s) => setState(() => _joining = s.first),
                ),
                const SizedBox(height: 20),
                if (_joining)
                  TextField(
                    key: const Key('inviteCode'),
                    controller: _code,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(labelText: 'Family code'),
                  )
                else
                  TextField(
                    key: const Key('childName'),
                    controller: _child,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Child’s first name',
                    ),
                  ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('parentName'),
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Your name (what your partner sees)',
                  ),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _busy ? null : _submit,
                  child: Text(_joining ? 'Join family' : 'Create family'),
                ),
                const SizedBox(height: 12),
                Text(
                  'Only first names are stored. Worksheet photos are deleted '
                  'right after they’re read.',
                  style: t.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => client.auth.signOutDevice(),
                  style: TextButton.styleFrom(foregroundColor: C.ink2),
                  child: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
