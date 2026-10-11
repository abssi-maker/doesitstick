import 'dart:async';

import 'package:doesitstick_client/doesitstick_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/family_controller.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import 'digest_screen.dart';
import 'family_screen.dart';
import 'onboarding_screen.dart' show justJoined;
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
  StreamSubscription<FamilyEvent>? _cheers;
  OverlayEntry? _cheer;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    controller.start();
    controller.addListener(_welcome);
    _events = controller.events.listen((e) {
      if (!mounted || e.kind == 'info' && e.message.isEmpty) return;
      if (e.kind == 'joined') {
        final name = e.actorName ?? 'Your partner';
        final child = controller.home?.family.childName ?? '';
        showTogetherMoment(
          context,
          emoji: '🎉',
          title: '$name is in!',
          body:
              'You’re a team now. $name sees $child’s problems as you go, '
              'and can send $child a cheer from wherever they are.',
        );
        return;
      }
      toast(context, e.message);
      if (e.kind == 'recheck') setState(() => _tab = 1);
    });
    _cheers = controller.cheers.listen(_showCheer);
  }

  /// The parent who just joined lands with a welcome, not a blank screen.
  void _welcome() {
    final home = controller.home;
    if (!justJoined || home == null || !mounted) return;
    justJoined = false;
    final partner = controller.partner ?? 'your partner';
    final child = home.family.childName;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showTogetherMoment(
        context,
        emoji: '👋',
        title: 'You’re in with $partner',
        body:
            'When $partner sits down with $child, you’ll see it here live, '
            'and you can send $child a cheer.',
      );
    });
  }

  void _showCheer(FamilyEvent e) {
    if (!mounted) return;
    HapticFeedback.mediumImpact();
    _cheer?.remove();
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => CheerBanner(
        from: e.actorName ?? '',
        message: e.message,
        child: controller.home?.family.childName ?? '',
        onDone: () {
          if (_cheer == entry) _cheer = null;
          if (entry.mounted) entry.remove();
        },
      ),
    );
    _cheer = entry;
    Overlay.of(context, rootOverlay: true).insert(entry);
  }

  @override
  void dispose() {
    _cheer?.remove();
    _cheers?.cancel();
    controller.removeListener(_welcome);
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
                    RechecksScreen(onTryItOut: () => setState(() => _tab = 3)),
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
            (Icons.replay_rounded, 'Did it stick?'),
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
          Image.asset('assets/icon/favicon.png', width: 44, height: 44),
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

/// Shows up only when there's news: the other parent is here ("Sam is
/// with Maya" / "Sam is following along"), or there's no connection.
class TogetherChip extends StatelessWidget {
  const TogetherChip({super.key});

  @override
  Widget build(BuildContext context) {
    final c = FamilyScope.of(context);
    final p = c.partnerHere;
    final child = c.home?.family.childName ?? '';
    final queued = c.outbox.length;
    final (String text, Color bg, Color fg, Color dot)? look =
        c.sync == SyncState.offline
        ? (
            c.demoOffline
                ? 'Offline (try-out) · saving on this phone'
                : queued > 0
                ? 'No connection · $queued saved on this phone'
                : 'No connection · saving on this phone',
            C.sunS,
            C.sunT,
            C.sun,
          )
        : p == null
        ? null
        : (
            p.atTable
                ? '${p.name} is with $child'
                : p.detail == 'following'
                ? '${p.name} is following along'
                : '${p.name} is here too',
            C.mintS,
            C.mintT,
            C.mint,
          );
    if (look == null) return const SizedBox.shrink();
    final (text, bg, fg, dot) = look;
    return Container(
      key: const Key('togetherChip'),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Pulse(color: dot, live: p != null),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
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

/// A dot that breathes slowly while someone is live.
class _Pulse extends StatefulWidget {
  final Color color;
  final bool live;
  const _Pulse({required this.color, required this.live});

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final _a = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void initState() {
    super.initState();
    if (widget.live) _a.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(_Pulse old) {
    super.didUpdateWidget(old);
    if (widget.live && !_a.isAnimating) _a.repeat(reverse: true);
    if (!widget.live) _a.stop();
  }

  @override
  void dispose() {
    _a.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 1.0, end: 0.35).animate(_a),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}

/// A cheer from the parent who's away, big at the top of whatever screen
/// is open, to be read out to the child.
class CheerBanner extends StatefulWidget {
  final String from;
  final String message;
  final String child;
  final VoidCallback onDone;
  const CheerBanner({
    super.key,
    required this.from,
    required this.message,
    required this.child,
    required this.onDone,
  });

  @override
  State<CheerBanner> createState() => _CheerBannerState();
}

class _CheerBannerState extends State<CheerBanner>
    with SingleTickerProviderStateMixin {
  late final _a = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  )..forward();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 9), _close);
  }

  Future<void> _close() async {
    _timer?.cancel();
    if (!mounted) return;
    await _a.reverse();
    widget.onDone();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _a.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, -1.2),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: _a, curve: Curves.easeOutBack)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Material(
                key: const Key('cheerBanner'),
                color: C.grape,
                elevation: 8,
                shadowColor: C.grapeD,
                borderRadius: BorderRadius.circular(24),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: _close,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
                    child: Row(
                      children: [
                        const Text('💛', style: TextStyle(fontSize: 34)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${widget.from} sent a cheer',
                                style: t.bodySmall!.copyWith(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '“${widget.message}”',
                                style: t.titleMedium!.copyWith(
                                  color: Colors.white,
                                  fontSize: 19,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Read it out to ${widget.child}.',
                                style: t.bodySmall!.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A big moment, not a toast: the family now has both grown-ups.
Future<void> showTogetherMoment(
  BuildContext context, {
  required String emoji,
  required String title,
  required String body,
}) => showDialog<void>(
  context: context,
  builder: (context) {
    final t = Theme.of(context).textTheme;
    return AlertDialog(
      backgroundColor: C.cream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.4, end: 1),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (_, v, child) => Transform.scale(scale: v, child: child),
            child: Text(emoji, style: const TextStyle(fontSize: 64)),
          ),
          const SizedBox(height: 12),
          Text(title, style: t.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            body,
            style: t.bodyMedium!.copyWith(color: C.ink2),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          key: const Key('togetherOk'),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Nice'),
        ),
      ],
    );
  },
);

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
            const Flexible(flex: 3, child: TogetherChip()),
          ],
        ),
        const SizedBox(height: 6),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}
