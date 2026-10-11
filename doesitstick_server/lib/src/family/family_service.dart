import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_offline_sync_server/serverpod_offline_sync_server.dart';

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
    // A retry after a lost reply (slow network, app closed mid-call) must not
    // strand the parent: they already have a family, so hand it back.
    final existing = await memberOf(session);
    if (existing != null) return existing;
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
    final existing = await memberOf(session);
    final parent = _clean(parentName, 'your name');
    final family = await Family.db.findFirstRow(
      session,
      where: (t) => t.inviteCode.equals(inviteCode.trim().toUpperCase()),
    );
    if (family == null) {
      throw DidItStickException(message: 'That code doesn’t match a family.');
    }
    if (existing != null) {
      // Retrying a join that already went through is fine; switching
      // families is not.
      if (existing.familyId == family.id) return existing;
      throw DidItStickException(message: 'You are already in another family.');
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
    final space = await ensureSpace(session, family.id!);
    await session.offlineSync.spaces.grant(
      space: space,
      user: auth.authUserId,
      role: OfflineSyncSpaceRole.readWrite,
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

  /// The family's offline sync space: both parents' phones read and write
  /// marks in it. Created on first use, so families made before offline sync
  /// get one too, with every parent granted read-write.
  static Future<UuidValue> ensureSpace(Session session, int familyId) async {
    final family = (await Family.db.findById(session, familyId))!;
    final existing = family.syncSpace;
    if (existing != null) return existing;
    final parents = await FamilyMember.db.find(
      session,
      where: (t) => t.familyId.equals(familyId),
    );
    final space = await session.offlineSync.spaces.create(
      grants: {
        for (final p in parents)
          if (p.authUserId != null)
            p.authUserId!: OfflineSyncSpaceRole.readWrite,
      },
    );
    await Family.db.updateRow(session, family.copyWith(syncSpace: space));
    return space;
  }

  static Future<FamilyView> view(
    Session session,
    FamilyMember member, {
    String? shareBaseUrl,
  }) async {
    final space = await ensureSpace(session, member.familyId);
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
      syncSpace: space,
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
