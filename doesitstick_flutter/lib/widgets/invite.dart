import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'common.dart';

/// Where the web app lives; links open it with the invite code filled in.
const _publicWebUrl = 'https://doesitstick.serverpod.space';

/// An invite code from a link like /join/KQ8CYH, when the web app was opened
/// from one.
final String? inviteCodeFromLink = () {
  if (!kIsWeb) return null;
  final segments = Uri.base.pathSegments;
  if (segments.length == 2 && segments[0] == 'join') {
    return segments[1].toUpperCase();
  }
  return null;
}();

String inviteLink(String code) =>
    '${kIsWeb ? Uri.base.origin : _publicWebUrl}/join/$code';

/// Opens the share sheet (WhatsApp, Messages, email…) with a ready-made
/// invite; copies it instead where sharing isn't available.
Future<void> sendInvite(
  BuildContext context, {
  required String childName,
  required String code,
}) async {
  final text =
      'Join me on Did It Stick to help $childName with math homework, '
      'calmly: ${inviteLink(code)}\n'
      '(If it asks for a code: $code)';
  try {
    final result = await SharePlus.instance.share(
      ShareParams(text: text, subject: 'Help with $childName’s homework'),
    );
    if (result.status != ShareResultStatus.unavailable) return;
  } catch (_) {
    // Fall through to copying.
  }
  await Clipboard.setData(ClipboardData(text: text));
  if (context.mounted) {
    toast(context, 'Invite copied. Paste it in a message to your partner.');
  }
}
