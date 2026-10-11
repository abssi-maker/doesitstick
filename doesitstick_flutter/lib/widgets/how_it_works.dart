import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'common.dart';

/// Each step a parent sees, and what does the work behind it.
const _steps = [
  (
    '📸',
    'You snap the worksheet',
    'The photo goes to private Serverpod file storage. Only your family can '
        'open it; a scheduled clean-up deletes it after 7 days.',
  ),
  (
    '✦',
    'It gets read in the background',
    'A Serverpod future call sends the photo to Google Gemini, so your phone '
        'never waits. Both phones get the result over a live stream.',
  ),
  (
    '✓',
    'Every number is double-checked',
    'Gemini only names the topic and copies the problems. Serverpod code '
        'builds each question and re-checks every answer a second, '
        'independent way. A misread problem is dropped, never trusted.',
  ),
  (
    '👪',
    'Your partner follows live',
    'Serverpod streams push each answer to the other parent’s phone the '
        'moment it’s marked.',
  ),
  (
    '🔁',
    'It comes back on day 2 and 7',
    'Serverpod future calls are scheduled for each re-check, with new '
        'numbers. A sweep every 15 minutes catches any that were missed.',
  ),
  (
    '📶',
    'Bad Wi-Fi is fine',
    'Serverpod offline sync keeps the family’s marks on each phone. Mark '
        'with no connection; it syncs when you’re back, and both phones agree.',
  ),
  (
    '🔐',
    'No sign-up',
    'Serverpod authentication with one-tap accounts; email is optional.',
  ),
];

Future<void> showHowItWorks(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  backgroundColor: C.cream,
  showDragHandle: true,
  isScrollControlled: true,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
  ),
  builder: (context) {
    final t = Theme.of(context).textTheme;
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
          children: [
            const Eyebrow('Under the hood'),
            const SizedBox(height: 4),
            Text('How it works', style: t.headlineSmall),
            const SizedBox(height: 6),
            Text(
              'One Dart codebase: a Flutter app on the phone and the web, and '
              'a Serverpod server on Serverpod Cloud.',
              style: t.bodyMedium!.copyWith(color: C.ink2),
            ),
            const SizedBox(height: 16),
            for (final (icon, title, body) in _steps)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 32,
                      child: Text(icon, style: const TextStyle(fontSize: 22)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: t.titleMedium),
                          const SizedBox(height: 2),
                          Text(body, style: t.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  },
);
