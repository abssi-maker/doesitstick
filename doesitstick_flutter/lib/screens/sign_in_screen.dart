import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

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
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: ListView(
              padding: const EdgeInsets.all(22),
              children: [
                const SizedBox(height: 24),
                const Eyebrow('Did It Stick'),
                const SizedBox(height: 6),
                Text('Did tonight’s math really click?', style: t.displaySmall),
                const SizedBox(height: 10),
                Text(
                  'Snap the worksheet. Ask 3 quick questions. '
                  'We check back in 2 and 7 days.',
                  style: t.bodyLarge!.copyWith(color: C.ink2),
                ),
                const SizedBox(height: 18),
                const Stick(says: 'No account needed. Just tap start.'),
                const SizedBox(height: 22),
                ListenableBuilder(
                  listenable: _anonymous,
                  builder: (context, _) => FilledButton(
                    key: const Key('getStarted'),
                    onPressed: _anonymous.isLoading ? null : _anonymous.login,
                    child: Text(
                      _anonymous.isLoading ? 'Starting…' : 'Get started',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() => _showEmail = !_showEmail),
                  style: TextButton.styleFrom(foregroundColor: C.ink2),
                  child: Text(
                    _showEmail ? 'Hide email sign-in' : 'Sign in with email',
                  ),
                ),
                if (_showEmail)
                  Panel(
                    padding: const EdgeInsets.all(8),
                    child: SignInWidget(
                      client: client,
                      disableAnonymousSignInWidget: true,
                      onError: (error) =>
                          toast(context, 'Sign-in failed: $error'),
                    ),
                  ),
                const SizedBox(height: 16),
                const Center(
                  child: Pill(
                    'Build 2 · one-tap start · Oct 9',
                    bg: C.mintS,
                    fg: C.mintT,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
