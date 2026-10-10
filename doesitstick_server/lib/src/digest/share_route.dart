import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'digest_service.dart';

/// Public, read-only weekly page at `/s/:token`. No photos, no answers, no
/// parent emails: just the child's first name and what stuck.
class ShareDigestRoute extends Route {
  @override
  Future<Result> handleCall(Session session, Request request) async {
    final token = request.pathParameters.raw[#token];
    final family = token == null || token.length < 16
        ? null
        : await Family.db.findFirstRow(
            session,
            where: (t) => t.shareToken.equals(token),
          );
    if (family == null) {
      // 410, not 404: the link existed and was turned off (and the dev
      // fallback page only replaces 404s).
      return Response(
        410,
        body: Body.fromString(
          _page(
            'Link turned off',
            '<p class="muted">This page was shared and '
                'then turned off by the family.</p>',
          ),
          mimeType: MimeType.html,
        ),
      );
    }
    final digest = await DigestService.weekly(session, family.id!);
    return Response.ok(
      body: Body.fromString(renderDigest(digest), mimeType: MimeType.html),
    );
  }

  static String _esc(String s) => s
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');

  static const _months = [
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
  static String _d(DateTime t) => '${_months[t.month - 1]} ${t.day}';

  static const _outcome = {
    Outcome.notYet: '🌱 not yet',
    Outcome.withHint: '💡 with a hint',
    Outcome.gotAnswer: '✓ got the answer',
    Outcome.explainedWhy: '★ explained why',
  };

  static String renderDigest(WeeklyDigest d) {
    final rows = StringBuffer();
    for (final c in d.concepts) {
      final label = switch (c.status) {
        'stuck' => '🌼 Stuck',
        'growing' => '🌱 Still growing',
        _ => '⏳ Waiting for re-check',
      };
      rows.write(
        '<section class="card ${c.status}"><div class="row">'
        '<h2>${_esc(c.title)}</h2><span class="chip">$label</span></div>'
        '<p>${_esc(c.reason)}</p><ul>',
      );
      for (final e in c.evidence) {
        final when = e.recheckDay == 0
            ? 'Tonight'
            : 'Day ${e.recheckDay} re-check';
        rows.write(
          '<li><b>${_d(e.at)}</b> · $when · ${_outcome[e.outcome]}</li>',
        );
      }
      rows.write('</ul></section>');
    }
    if (d.concepts.isEmpty) {
      rows.write('<p class="muted">No questions asked this week yet.</p>');
    }
    final body =
        '<p class="eyebrow">${_d(d.weekStart)} – ${_d(d.weekEnd)}</p>'
        '<h1>What stuck for ${_esc(d.childName)}</h1>'
        '<p class="sum">${d.stuckCount} stuck · ${d.growingCount} still growing</p>'
        '$rows'
        '<p class="muted foot">“Stuck” means it held up on a re-check days later '
        'with new numbers. Three questions are a signal, not a grade.</p>';
    return _page('What stuck for ${d.childName}', body);
  }

  static String _page(String title, String body) =>
      '''<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="robots" content="noindex">
<title>${_esc(title)} · Did It Stick</title>
<style>
body{margin:0;background:#FFF8EE;color:#2A2350;font:16px/1.5 ui-rounded,system-ui,-apple-system,sans-serif}
main{max-width:560px;margin:0 auto;padding:32px 22px 48px}
h1{font-size:30px;font-weight:600;margin:4px 0 6px}
h2{font-size:18px;font-weight:600;margin:0}
.eyebrow{color:#4A2FC4;font-weight:600;margin:0}.sum{color:#6B6487;margin:0 0 20px}
.card{background:#fff;border-radius:24px;padding:18px 20px;margin:12px 0;box-shadow:0 1px 2px rgba(78,51,207,.06),0 12px 28px -12px rgba(78,51,207,.28)}
.row{display:flex;justify-content:space-between;gap:12px;align-items:center}
.chip{font-size:14px;border-radius:999px;padding:4px 12px;white-space:nowrap}
.stuck .chip{background:#DDF7EC;color:#157A52}.growing .chip{background:#FFF4D1;color:#8A5A00}.waiting .chip{background:#E3F3FF;color:#1C6BA8}
ul{margin:8px 0 0;padding-left:18px;color:#6B6487;font-size:14px}.muted{color:#6B6487}.foot{font-size:14px;margin-top:24px}
</style></head><body><main>$body</main></body></html>''';
}
