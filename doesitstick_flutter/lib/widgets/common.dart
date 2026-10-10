import 'package:doesitstick_client/doesitstick_client.dart';
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Stick, the sticky-note mascot. Speaks in 8 words or fewer.
class Stick extends StatelessWidget {
  final String says;
  final String mood;
  const Stick({super.key, required this.says, this.mood = '🌱'});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.rotate(
          angle: -0.08,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: C.sun,
              borderRadius: BorderRadius.circular(10),
              boxShadow: shadow,
            ),
            alignment: Alignment.center,
            child: Text(mood, style: const TextStyle(fontSize: 22)),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: C.sunS,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              says,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: C.sunT,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Panel extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  const Panel({
    super.key,
    required this.child,
    this.color = C.paper,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: color == C.paper ? shadow : null,
      ),
      child: child,
    );
  }
}

class Pill extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  const Pill(this.text, {super.key, this.bg = C.grapeS, this.fg = C.grapeT});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class Eyebrow extends StatelessWidget {
  final String text;
  const Eyebrow(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: const TextStyle(
      color: C.grapeT,
      fontSize: 12,
      letterSpacing: 1.1,
      fontWeight: FontWeight.w600,
    ),
  );
}

const months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

String shortDate(DateTime t) {
  final l = t.toLocal();
  return '${weekdays[l.weekday - 1]}, ${months[l.month - 1]} ${l.day}';
}

String clock(DateTime t) {
  final l = t.toLocal();
  final h = l.hour % 12 == 0 ? 12 : l.hour % 12;
  return '$h:${l.minute.toString().padLeft(2, '0')} ${l.hour < 12 ? 'am' : 'pm'}';
}

void toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

String errorText(Object e) {
  if (e is DidItStickException) return e.message;
  final s = e.toString();
  final m = RegExp(r'message: ([^,)]+)').firstMatch(s);
  return m?.group(1) ?? 'Something went wrong. Please try again.';
}
