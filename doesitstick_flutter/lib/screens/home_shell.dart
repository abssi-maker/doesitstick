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
          final content = controller.home == null
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
                );
          final recheckIcon = Badge(
            isLabelVisible: rechecks > 0,
            label: Text('$rechecks'),
            backgroundColor: C.sun,
            textColor: C.ink,
            child: const Icon(Icons.replay_rounded),
          );
          const tabs = [
            (Icons.wb_twilight_rounded, 'Tonight'),
            (Icons.replay_rounded, 'Re-checks'),
            (Icons.local_florist_rounded, 'What stuck'),
            (Icons.people_alt_rounded, 'Family'),
          ];
          return LayoutBuilder(
            builder: (context, box) {
              // Laptops and tablets (and judges on the web): a side rail
              // with the promise in view; phones keep the bottom bar.
              if (box.maxWidth >= 900) {
                return Scaffold(
                  body: SafeArea(
                    child: Row(
                      children: [
                        NavigationRail(
                          extended: box.maxWidth >= 1100,
                          backgroundColor: C.paper,
                          selectedIndex: _tab,
                          onDestinationSelected: (i) =>
                              setState(() => _tab = i),
                          leading: _RailBrand(compact: box.maxWidth < 1100),
                          destinations: [
                            for (var i = 0; i < tabs.length; i++)
                              NavigationRailDestination(
                                icon: i == 1 ? recheckIcon : Icon(tabs[i].$1),
                                label: Text(tabs[i].$2),
                              ),
                          ],
                        ),
                        const VerticalDivider(width: 1, color: C.line),
                        Expanded(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 680),
                              child: content,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Scaffold(
                body: SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: content,
                    ),
                  ),
                ),
                bottomNavigationBar: NavigationBar(
                  selectedIndex: _tab,
                  onDestinationSelected: (i) => setState(() => _tab = i),
                  destinations: [
                    for (var i = 0; i < tabs.length; i++)
                      NavigationDestination(
                        icon: i == 1 ? recheckIcon : Icon(tabs[i].$1),
                        label: tabs[i].$2,
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Name and promise at the top of the side rail.
class _RailBrand extends StatelessWidget {
  final bool compact;
  const _RailBrand({required this.compact});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 24),
      child: Column(
        children: [
          const Text('🌱', style: TextStyle(fontSize: 30)),
          if (!compact) ...[
            const SizedBox(height: 4),
            Text('Did It Stick', style: t.titleMedium),
            Text('Calm math homework', style: t.bodySmall),
          ],
        ],
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
