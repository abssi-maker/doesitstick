import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

/// Family membership and the live channel both parents listen on.
class FamilyService {
  static const maxParents = 2;
  static const _codeChars = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';

  static String channel(int familyId) => 'family-$familyId';

  static Future<FamilyMember?> memberOf(Session session) async {
    final auth = session.authenticated;
    if (auth == null) return null;
    return FamilyMember.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(auth.authUserId),
    );
  }

  /// The caller's membership. Every family-scoped call goes through here, so
  /// a signed-in user can never touch another family's records.
  static Future<FamilyMember> requireMember(Session session) async {
    final member = await memberOf(session);
    if (member == null) {
      throw DidItStickException(message: 'Create or join a family first.');
    }
    return member;
  }

  static String newCode([Random? random]) {
    final r = random ?? Random.secure();
    return List.generate(
      6,
      (_) => _codeChars[r.nextInt(_codeChars.length)],
    ).join();
  }

  static Future<FamilyMember> create(
    Session session, {
    required String childName,
    required String parentName,
  }) async {
    final auth = session.authenticated!;
    if (await memberOf(session) != null) {
      throw DidItStickException(message: 'You are already in a family.');
    }
    final child = _clean(childName, 'child’s name');
    final parent = _clean(parentName, 'your name');
    return session.db.transaction((tx) async {
      final family = await Family.db.insertRow(
        session,
        Family(childName: child, inviteCode: newCode()),
        transaction: tx,
      );
      return FamilyMember.db.insertRow(
        session,
        FamilyMember(
          familyId: family.id!,
          authUserId: auth.authUserId,
          displayName: parent,
        ),
        transaction: tx,
      );
    });
  }

  static Future<FamilyMember> join(
    Session session, {
    required String inviteCode,
    required String parentName,
  }) async {
    final auth = session.authenticated!;
    if (await memberOf(session) != null) {
      throw DidItStickException(message: 'You are already in a family.');
    }
    final parent = _clean(parentName, 'your name');
    final family = await Family.db.findFirstRow(
      session,
      where: (t) => t.inviteCode.equals(inviteCode.trim().toUpperCase()),
    );
    if (family == null) {
      throw DidItStickException(message: 'That code doesn’t match a family.');
    }
    final count = await FamilyMember.db.count(
      session,
      where: (t) => t.familyId.equals(family.id!),
    );
    if (count >= maxParents) {
      throw DidItStickException(
        message: 'This family already has two parents.',
      );
    }
    final member = await FamilyMember.db.insertRow(
      session,
      FamilyMember(
        familyId: family.id!,
        authUserId: auth.authUserId,
        displayName: parent,
      ),
    );
    await postEvent(
      session,
      family.id!,
      kind: 'joined',
      message: '$parent joined the family',
      actorName: parent,
    );
    return member;
  }

  static Future<FamilyView> view(
    Session session,
    FamilyMember member, {
    String? shareBaseUrl,
  }) async {
    final family = await Family.db.findById(session, member.familyId);
    final parents = await FamilyMember.db.find(
      session,
      where: (t) => t.familyId.equals(member.familyId),
      orderBy: (t) => t.joinedAt,
    );
    final token = family!.shareToken;
    return FamilyView(
      familyId: family.id!,
      childName: family.childName,
      inviteCode: family.inviteCode,
      me: member.displayName,
      parents: parents.map((p) => p.displayName).toList(),
      shareUrl: token == null || shareBaseUrl == null
          ? null
          : '$shareBaseUrl/s/$token',
    );
  }

  static Future<void> postEvent(
    Session session,
    int familyId, {
    required String kind,
    required String message,
    String? actorName,
    int? cardId,
  }) async {
    await session.messages.postMessage(
      channel(familyId),
      FamilyEvent(
        kind: kind,
        message: message,
        actorName: actorName,
        cardId: cardId,
        at: DateTime.now().toUtc(),
      ),
    );
  }

  static String _clean(String value, String label) {
    final v = value.trim();
    if (v.isEmpty || v.length > 40) {
      throw DidItStickException(message: 'Please enter $label (1–40 letters).');
    }
    return v;
  }
}
