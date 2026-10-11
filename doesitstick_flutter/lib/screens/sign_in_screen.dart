import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../widgets/how_it_works.dart';

/// Every feature, in the order a parent meets them. Shown on the welcome
/// screen so the promise is clear before signing in.
const _features = [
  (
    '📸',
    'Snap the worksheet',
    'Google Gemini reads the problems and the topic. The photo stays '
        'private to your family and is deleted after 7 days.',
  ),
  (
    '🗣️',
    'The words to say',
    'The class method, what to ask, and hints that never give the answer '
        'away.',
  ),
  (
    '🔎',
    'Help for the wrong answer',
    'Type what they said: see the likely slip and what to ask next. If it '
        'isn’t clicking, a kind way to stop.',
  ),
  (
    '✓',
    'Every answer double-checked',
    'The AI only reads the page. Serverpod code builds and re-checks every '
        'number.',
  ),
  (
    '👪',
    'Both parents, together',
    'Your partner follows live from work and can send your child a cheer.',
  ),
  (
    '🔁',
    'Did it stick?',
    'A quick check on day 2 and day 7, with new numbers.',
  ),
  (
    '🌼',
    'What stuck this week',
    'A weekly summary of what really stuck.',
  ),
  (
    '📶',
    'Works with bad Wi-Fi',
    'Marks are saved on the phone and sent when you’re back online.',
  ),
];

class SignInScreen extends StatefulWidget {
  final Widget child;
  const SignInScreen({super.key, required this.child});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isSignedIn = false;
  bool _showEmail = false;
  late final _anonymous = AnonymousAuthController(
    client: client,
    onError: (e) => toast(context, 'Couldn’t start: $e'),
  );

  @override
  void initState() {
    super.initState();
    client.auth.authInfoListenable.addListener(_updateSignedInState);
    _isSignedIn = client.auth.isAuthenticated;
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_updateSignedInState);
    _anonymous.dispose();
    super.dispose();
  }

  void _updateSignedInState() {
    setState(() => _isSignedIn = client.auth.isAuthenticated);
  }

  @override
  Widget build(BuildContext context) {
    if (_isSignedIn) return widget.child;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, box) {
            if (box.maxWidth >= 900) {
              return Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      color: C.grapeS,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(56, 56, 56, 40),
                        children: const [
                          _Pitch(),
                          SizedBox(height: 32),
                          _FeatureGrid(columns: 2),
                          SizedBox(height: 28),
                          _Evidence(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(32),
                          children: _start(context),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: ListView(
                  padding: const EdgeInsets.all(22),
                  children: [
                    const SizedBox(height: 16),
                    const _Pitch(),
                    const SizedBox(height: 22),
                    ..._start(context),
                    const SizedBox(height: 28),
                    const _FeatureGrid(columns: 1),
                    const SizedBox(height: 16),
                    const _Evidence(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _start(BuildContext context) => [
    const Stick(says: 'No account needed. Just tap start.'),
    const SizedBox(height: 18),
    ListenableBuilder(
      listenable: _anonymous,
      builder: (context, _) => FilledButton(
        key: const Key('getStarted'),
        onPressed: _anonymous.isLoading ? null : _anonymous.login,
        child: Text(_anonymous.isLoading ? 'Starting…' : 'Get started'),
      ),
    ),
    const SizedBox(height: 8),
    TextButton(
      onPressed: () => setState(() => _showEmail = !_showEmail),
      style: TextButton.styleFrom(foregroundColor: C.ink2),
      child: Text(
        _showEmail
            ? 'Hide email sign-in'
            : 'Using another phone? Sign in with email',
      ),
    ),
    if (_showEmail)
      Panel(
        padding: const EdgeInsets.all(8),
        child: SignInWidget(
          client: client,
          disableAnonymousSignInWidget: true,
          onError: (error) => toast(context, 'Sign-in failed: $error'),
        ),
      ),
  ];
}

class _Pitch extends StatelessWidget {
  const _Pitch();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/icon/favicon.png', width: 64, height: 64),
        const SizedBox(height: 14),
        const Eyebrow('Did It Stick · calm math homework'),
        const SizedBox(height: 8),
        Text('Math homework, without the yelling.', style: t.displaySmall),
        const SizedBox(height: 12),
        Text(
          'You don’t need to be a math teacher. Snap tonight’s worksheet and '
          'we’ll tell you what to say, the way the class teaches it, and when '
          'to stop. Then we check it stuck.',
          style: t.bodyLarge!.copyWith(color: C.ink2),
        ),
      ],
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  final int columns;
  const _FeatureGrid({required this.columns});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    Widget tile((String, String, String) f) => Panel(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Center(
              child: Text(f.$1, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(f.$2, style: t.titleMedium),
                const SizedBox(height: 2),
                Text(f.$3, style: t.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
    // Natural heights (no IntrinsicHeight: it under-measures wrapped text),
    // with a shared minimum so two-column rows still line up.
    final rows = <Widget>[];
    for (var i = 0; i < _features.length; i += columns) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var j = i; j < i + columns && j < _features.length; j++) ...[
                if (j > i) const SizedBox(width: 12),
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: columns > 1 ? 112 : 0,
                    ),
                    child: tile(_features[j]),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

class _Evidence extends StatelessWidget {
  const _Evidence();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          key: const Key('howItWorks'),
          onPressed: () => showHowItWorks(context),
          icon: const Icon(Icons.info_outline_rounded),
          label: const Text('How it works, under the hood'),
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
        ),
        const SizedBox(height: 8),
        _evidenceText(context),
      ],
    );
  }

  Widget _evidenceText(BuildContext context) {
    return Text(
      'Why calm matters: parents’ stress while helping, not their math '
      'skills, is what lowers children’s math learning and confidence '
      '(Maloney et al., Psychological Science, 2015).\n'
      'Built with Flutter and Serverpod: one Dart codebase for the phone, '
      'the web and the server.',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
