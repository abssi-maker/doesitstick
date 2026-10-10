import 'dart:async';

import 'package:doesitstick_client/doesitstick_client.dart';
import 'package:flutter/material.dart';

import '../state/family_controller.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import 'digest_screen.dart';
import 'family_screen.dart';
import 'rechecks_screen.dart';
import 'tonight_screen.dart';

class FamilyScope extends InheritedNotifier<FamilyController> {
  const FamilyScope({
    super.key,
    required FamilyController controller,
    required super.child,
  }) : super(notifier: controller);

  static FamilyController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FamilyScope>()!.notifier!;
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final controller = FamilyController();
  StreamSubscription<FamilyEvent>? _events;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    controller.start();
    _events = controller.events.listen((e) {
      if (!mounted || e.kind == 'info' && e.message.isEmpty) return;
      toast(context, e.message);
      if (e.kind == 'recheck') setState(() => _tab = 1);
    });
  }

  @override
  void dispose() {
    _events?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FamilyScope(
      controller: controller,
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final rechecks = controller.openRechecks.length;
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: controller.home == null
                      ? const Center(child: CircularProgressIndicator())
                      : IndexedStack(
                          index: _tab,
                          children: [
                            TonightScreen(
                              onOpenRechecks: () => setState(() => _tab = 1),
                            ),
                            const RechecksScreen(),
                            const DigestScreen(),
                            const FamilyScreen(),
                          ],
                        ),
                ),
              ),
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _tab,
              onDestinationSelected: (i) => setState(() => _tab = i),
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.wb_twilight_rounded),
                  label: 'Tonight',
                ),
                NavigationDestination(
                  icon: Badge(
                    isLabelVisible: rechecks > 0,
                    label: Text('$rechecks'),
                    backgroundColor: C.sun,
                    textColor: C.ink,
                    child: const Icon(Icons.replay_rounded),
                  ),
                  label: 'Re-checks',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.local_florist_rounded),
                  label: 'What stuck',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.people_alt_rounded),
                  label: 'Family',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// "Live with Sam" / "Reconnecting…" / "Offline · 2 saved on this phone".
class SyncChip extends StatelessWidget {
  const SyncChip({super.key});

  @override
  Widget build(BuildContext context) {
    final c = FamilyScope.of(context);
    final queued = c.outbox.length;
    final partner = c.partner;
    final (text, bg, fg, dot) = switch (c.sync) {
      SyncState.live => (
        partner == null ? 'Live' : 'Live with $partner',
        C.mintS,
        C.mintT,
        C.mint,
      ),
      SyncState.connecting => ('Connecting…', C.skyS, C.skyT, C.sky),
      SyncState.offline => (
        c.demoOffline ? 'Offline (demo)' : 'Offline',
        C.sunS,
        C.sunT,
        C.sun,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              queued > 0 ? '$text · $queued saved on this phone' : text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: fg,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  const ScreenHeader({super.key, required this.eyebrow, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Eyebrow(eyebrow)),
            const Flexible(flex: 3, child: SyncChip()),
          ],
        ),
        const SizedBox(height: 6),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}
