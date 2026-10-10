import 'package:doesitstick_client/doesitstick_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'client.dart';
import 'screens/home_shell.dart';
import 'screens/onboarding_screen.dart';
import 'screens/sign_in_screen.dart';
import 'theme/tokens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Keep the status and navigation bars visible; the app draws behind them
  // (screens use SafeArea / AppBar) with dark icons on the light background.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      // Matches the white tab bar at the bottom of the home screens.
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarContrastEnforced: false,
    ),
  );
  await initializeClient();
  runApp(const DidItStickApp());
}

class DidItStickApp extends StatelessWidget {
  const DidItStickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Did It Stick',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const SignInScreen(child: FamilyGate()),
    );
  }
}

/// Signed in, but maybe not paired yet: create or join a family first.
class FamilyGate extends StatefulWidget {
  const FamilyGate({super.key});

  @override
  State<FamilyGate> createState() => _FamilyGateState();
}

class _FamilyGateState extends State<FamilyGate> {
  late Future<FamilyView?> _me = client.family.me();

  void _reload() => setState(() => _me = client.family.me());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FamilyView?>(
      future: _me,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Can’t reach Did It Stick right now.'),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _reload,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }
        final family = snap.data;
        if (family == null) return OnboardingScreen(onDone: _reload);
        return HomeShell(key: ValueKey(family.familyId));
      },
    );
  }
}
