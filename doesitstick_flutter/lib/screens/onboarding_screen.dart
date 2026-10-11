import 'package:doesitstick_client/doesitstick_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../widgets/invite.dart';

/// Set when this parent has just joined their partner's family, so the
/// home screen opens with a welcome.
bool justJoined = false;

/// Sets this parent up: start a family for the child (then, optionally,
/// invite the partner), or join from a partner's invite.
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onDone;
  const OnboardingScreen({super.key, required this.onDone});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _invited = inviteCodeFromLink;
  late bool _joining = _invited != null;
  bool _busy = false;
  bool _sent = false;
  FamilyView? _created;
  final _child = TextEditingController();
  late final _code = TextEditingController(text: _invited ?? '');
  final _name = TextEditingController();

  Future<void> _submit() async {
    setState(() => _busy = true);
    try {
      if (_joining) {
        await client.family.join(_code.text, _name.text);
        justJoined = true;
        widget.onDone();
      } else {
        final family = await client.family.create(_child.text, _name.text);
        if (mounted) setState(() => _created = family);
      }
    } catch (e) {
      // The family may have been set up even though the reply was lost;
      // if so, carry on instead of leaving the parent on this screen.
      final family = await client.family.me().catchError((_) => null);
      if (family != null) {
        widget.onDone();
      } else if (mounted) {
        toast(context, errorText(e));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final created = _created;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: ListView(
              padding: const EdgeInsets.all(22),
              children: created != null ? _invite(created) : _setup(),
            ),
          ),
        ),
      ),
    );
  }

  /// Step 2, after starting a family: bring the partner in, or skip.
  List<Widget> _invite(FamilyView family) {
    final t = Theme.of(context).textTheme;
    return [
      const SizedBox(height: 16),
      const Eyebrow('Almost done'),
      const SizedBox(height: 6),
      Text('Homework is easier with two', style: t.displaySmall),
      const SizedBox(height: 16),
      Stick(
        says:
            'Invite your partner. They’ll see every problem and answer live '
            'on their phone.',
        mood: '👪',
      ),
      const SizedBox(height: 24),
      FilledButton.icon(
        key: const Key('sendInvite'),
        onPressed: () async {
          await sendInvite(
            context,
            childName: family.childName,
            code: family.inviteCode,
          );
          if (mounted) setState(() => _sent = true);
        },
        icon: const Icon(Icons.send_rounded),
        label: const Text('Send an invite'),
      ),
      const SizedBox(height: 10),
      OutlinedButton(
        key: const Key('skipInvite'),
        onPressed: widget.onDone,
        child: Text(_sent ? 'Continue' : 'Skip for now'),
      ),
      const SizedBox(height: 16),
      Text(
        'You can invite them later from the Family tab. '
        'Their code is ${family.inviteCode}.',
        style: t.bodySmall,
        textAlign: TextAlign.center,
      ),
    ];
  }

  /// Step 1: start a family, or join one from an invite.
  List<Widget> _setup() {
    final t = Theme.of(context).textTheme;
    return [
      const SizedBox(height: 16),
      const Eyebrow('Set up'),
      const SizedBox(height: 6),
      Text(
        _joining ? 'Join your partner' : 'Whose homework are we helping with?',
        style: t.displaySmall,
      ),
      const SizedBox(height: 16),
      Stick(
        says: _invited != null
            ? 'You’ve been invited. Just add your name.'
            : _joining
            ? 'Use the code from your partner’s invite.'
            : 'Your child needs no account or phone.',
        mood: _invited != null ? '💌' : '🌱',
      ),
      const SizedBox(height: 20),
      SegmentedButton<bool>(
        segments: const [
          ButtonSegment(value: false, label: Text('I’m starting')),
          ButtonSegment(value: true, label: Text('I was invited')),
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
          decoration: const InputDecoration(
            labelText: 'Invite code (6 letters, in the invite)',
          ),
        )
      else
        TextField(
          key: const Key('childName'),
          controller: _child,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Child’s first name'),
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
        child: Text(_joining ? 'Join' : 'Continue'),
      ),
      const SizedBox(height: 12),
      Text(
        'Only first names are stored. Worksheet photos are read by Google '
        'Gemini, kept private to your family, and deleted after 7 days.',
        style: t.bodySmall,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: () async {
          if (await confirmSignOut(context)) {
            await client.auth.signOutDevice();
          }
        },
        style: TextButton.styleFrom(foregroundColor: C.ink2),
        child: const Text('Sign out'),
      ),
    ];
  }
}
