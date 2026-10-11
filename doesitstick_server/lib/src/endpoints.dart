import 'dart:math';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_offline_sync_server/serverpod_offline_sync_server.dart';

import 'cards/card_service.dart';
import 'digest/digest_service.dart';
import 'family/family_service.dart';
import 'generated/future_calls.dart';
import 'generated/protocol.dart';
import 'jobs.dart';
import 'math/concepts.dart';
import 'rechecks/recheck_service.dart';
import 'worksheets/worksheet_reader.dart';
import 'worksheets/worksheet_service.dart';

String? _shareBase(Session session) {
  final web = session.serverpod.config.webServer;
  if (web == null) return null;
  final port =
      (web.publicScheme == 'https' && web.publicPort == 443) ||
          (web.publicScheme == 'http' && web.publicPort == 80)
      ? ''
      : ':${web.publicPort}';
  return '${web.publicScheme}://${web.publicHost}$port';
}

/// Pairing two parents into one family, and the live family stream.
class FamilyEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<FamilyView?> me(Session session) async {
    final member = await FamilyService.memberOf(session);
    if (member == null) return null;
    return FamilyService.view(
      session,
      member,
      shareBaseUrl: _shareBase(session),
    );
  }

  Future<FamilyView> create(
    Session session,
    String childName,
    String parentName,
  ) async {
    final member = await FamilyService.create(
      session,
      childName: childName,
      parentName: parentName,
    );
    return FamilyService.view(
      session,
      member,
      shareBaseUrl: _shareBase(session),
    );
  }

  Future<FamilyView> join(
    Session session,
    String inviteCode,
    String parentName,
  ) async {
    final member = await FamilyService.join(
      session,
      inviteCode: inviteCode,
      parentName: parentName,
    );
    return FamilyService.view(
      session,
      member,
      shareBaseUrl: _shareBase(session),
    );
  }

  /// Everything the home screen needs, in one call. The app also refetches
  /// this after reconnecting, so a missed stream event never loses data.
  Future<HomeState> home(Session session) async {
    final member = await FamilyService.requireMember(session);
    final fid = member.familyId;
    final cards = await QuestionCard.db.find(
      session,
      where: (t) => t.familyId.equals(fid),
      orderBy: (t) => t.createdAt.desc(),
      limit: 12,
    );
    return HomeState(
      family: await FamilyService.view(
        session,
        member,
        shareBaseUrl: _shareBase(session),
      ),
      worksheets: await Worksheet.db.find(
        session,
        where: (t) => t.familyId.equals(fid),
        orderBy: (t) => t.createdAt.desc(),
        limit: 5,
      ),
      cards: [for (final c in cards) await CardService.view(session, c)],
      rechecks: await Recheck.db.find(
        session,
        where: (t) => t.familyId.equals(fid),
        orderBy: (t) => t.dueAt,
      ),
      aiReaderEnabled: WorksheetReader.apiKey(session) != null,
    );
  }

  Future<List<ConceptOption>> concepts(Session session) async {
    return [
      for (final c in conceptInfos.values)
        ConceptOption(
          conceptId: c.id,
          title: c.title,
          grade: c.grade,
          methodName: c.methodName,
          example: c.example,
        ),
    ];
  }

  Stream<FamilyEvent> updates(Session session) async* {
    final member = await FamilyService.requireMember(session);
    yield FamilyEvent(
      kind: 'hello',
      message: 'Connected',
      at: DateTime.now().toUtc(),
    );
    yield* session.messages.createStream<FamilyEvent>(
      FamilyService.channel(member.familyId),
    );
  }

  static const _presence = {
    'working',
    'hint',
    'done',
    'following',
    'around',
    'gone',
  };

  /// Tells the other parent where this one is: on a problem with the child
  /// ([cardId], [step]), or just around. Only streamed, never stored. A
  /// phone that has just connected sets [greet], so the other phone answers
  /// at once instead of at its next ping.
  Future<void> presence(
    Session session,
    int? cardId,
    int? step,
    String detail, {
    required bool greet,
  }) async {
    final member = await FamilyService.requireMember(session);
    if (!_presence.contains(detail)) {
      throw DidItStickException(message: 'Unknown presence.');
    }
    if (cardId != null) {
      final card = await QuestionCard.db.findById(session, cardId);
      if (card == null || card.familyId != member.familyId) {
        throw DidItStickException(message: 'Card not found.');
      }
    }
    await session.messages.postMessage(
      FamilyService.channel(member.familyId),
      FamilyEvent(
        kind: 'presence',
        message: greet ? 'hi' : '',
        actorName: member.displayName,
        cardId: cardId,
        step: step,
        detail: detail,
        at: DateTime.now().toUtc(),
      ),
    );
  }

  static final _lastCheer = <int, DateTime>{};

  /// A preset cheer from the parent who is away, shown big at the table so
  /// it can be read out to the child.
  Future<void> cheer(Session session, Cheer cheer) async {
    final member = await FamilyService.requireMember(session);
    final now = DateTime.now().toUtc();
    final last = _lastCheer[member.id!];
    if (last != null && now.difference(last) < const Duration(seconds: 2)) {
      return;
    }
    _lastCheer[member.id!] = now;
    final family = await Family.db.findById(session, member.familyId);
    final child = family!.childName;
    await FamilyService.postEvent(
      session,
      member.familyId,
      kind: 'cheer',
      message: switch (cheer) {
        Cheer.proud => 'Proud of you for sticking with it, $child!',
        Cheer.thinking => 'Great thinking, $child!',
        Cheer.keepGoing => 'Keep going, $child. You’ve got this!',
      },
      actorName: member.displayName,
    );
  }
}

/// Worksheet photo upload and topic choice.
class WorksheetEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  static const maxPhotoBytes = 6 * 1024 * 1024;

  Future<PhotoUploadTicket> startPhoto(Session session) async {
    final member = await FamilyService.requireMember(session);
    final path =
        'family/${member.familyId}/worksheets/'
        '${DateTime.now().millisecondsSinceEpoch}-'
        '${Random.secure().nextInt(1 << 30)}.img';
    final ws = await Worksheet.db.insertRow(
      session,
      Worksheet(
        familyId: member.familyId,
        uploadedByName: member.displayName,
        photoPath: path,
        status: WorksheetStatus.uploaded,
      ),
    );
    final description = await session.storage.createUploadDescription(
      storageId: WorksheetService.storageId,
      path: path,
    );
    return PhotoUploadTicket(
      worksheetId: ws.id!,
      uploadDescription: description,
    );
  }

  /// Called after the upload finishes; hands the photo to the background job.
  Future<Worksheet> submitPhoto(Session session, int worksheetId) async {
    final member = await FamilyService.requireMember(session);
    final ws = await Worksheet.db.findById(session, worksheetId);
    if (ws == null || ws.familyId != member.familyId || ws.photoPath == null) {
      throw DidItStickException(message: 'Worksheet not found.');
    }
    final ok = await session.storage.verifyUpload(
      storageId: WorksheetService.storageId,
      path: ws.photoPath!,
    );
    if (!ok) {
      throw DidItStickException(message: 'The photo didn’t arrive. Try again.');
    }
    final stat = await session.storage.statFile(
      storageId: WorksheetService.storageId,
      path: ws.photoPath!,
    );
    if (stat.size > maxPhotoBytes) {
      await session.storage.deleteFile(
        storageId: WorksheetService.storageId,
        path: ws.photoPath!,
      );
      throw DidItStickException(message: 'That photo is too large.');
    }
    final reading = await Worksheet.db.updateRow(
      session,
      ws.copyWith(status: WorksheetStatus.reading),
    );
    if (Jobs.futureCallsOn(session.serverpod)) {
      await session.serverpod.futureCalls
          .callWithDelay(Duration.zero, identifier: 'worksheet-$worksheetId')
          .readWorksheet
          .read(worksheetId);
    } else {
      Jobs.runSoon(
        session.serverpod,
        'Reading worksheet $worksheetId',
        (s) => WorksheetService.process(s, worksheetId),
      );
    }
    await FamilyService.postEvent(
      session,
      member.familyId,
      kind: 'worksheet',
      message: '${member.displayName} snapped a worksheet',
      actorName: member.displayName,
    );
    return reading;
  }

  /// The worksheet photo, for either parent, while it's still kept.
  Future<ByteData?> photo(Session session, int worksheetId) async {
    final member = await FamilyService.requireMember(session);
    final ws = await Worksheet.db.findById(session, worksheetId);
    final path = ws?.photoPath;
    if (ws == null || ws.familyId != member.familyId || path == null) {
      return null;
    }
    return session.storage.retrieveFile(
      storageId: WorksheetService.storageId,
      path: path,
    );
  }

  /// Deletes the worksheet photo now instead of after the re-check week.
  Future<Worksheet> deletePhoto(Session session, int worksheetId) async {
    final member = await FamilyService.requireMember(session);
    final ws = await Worksheet.db.findById(session, worksheetId);
    if (ws == null || ws.familyId != member.familyId) {
      throw DidItStickException(message: 'Worksheet not found.');
    }
    final cleaned = await Worksheet.db.updateRow(
      session,
      await WorksheetService.deletePhoto(session, ws),
    );
    await FamilyService.postEvent(
      session,
      member.familyId,
      kind: 'worksheet',
      message: '${member.displayName} deleted the worksheet photo',
      actorName: member.displayName,
    );
    return cleaned;
  }

  /// Pick the topic directly (no photo), or correct the reader's guess.
  Future<Worksheet> chooseTopic(
    Session session,
    int? worksheetId,
    ConceptId conceptId,
  ) async {
    final member = await FamilyService.requireMember(session);
    var id = worksheetId;
    if (id == null) {
      final ws = await Worksheet.db.insertRow(
        session,
        Worksheet(
          familyId: member.familyId,
          uploadedByName: member.displayName,
          status: WorksheetStatus.needsTopic,
          note: 'Topic picked by ${member.displayName}',
        ),
      );
      id = ws.id!;
    }
    return WorksheetService.chooseTopic(session, member, id, conceptId);
  }
}

/// Serverpod offline sync for the family's marks: the module's CRDT sync,
/// plus a hook for when a phone's marks land on the server (complete cards,
/// schedule re-checks, tell the other parent).
class FamilySyncEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Stream<OfflineSyncStreamEvent> sync(
    Session session, {
    required Stream<OfflineSyncStreamEvent> changes,
    bool once = false,
  }) async* {
    final member = await FamilyService.requireMember(session);
    await FamilyService.ensureSpace(session, member.familyId);
    yield* session.offlineSync.sync(
      userId: UuidValue.withValidation(session.authenticated!.userIdentifier),
      inbound: changes,
      once: once,
      mode: OfflineSyncPeerMode.authoritative,
      onMergeSuccess: (_, _) => CardService.afterSync(session, member),
    );
  }
}

/// Cards and marks.
class CardEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<CardView> card(Session session, int cardId) async {
    final member = await FamilyService.requireMember(session);
    final card = await QuestionCard.db.findById(session, cardId);
    if (card == null || card.familyId != member.familyId) {
      throw DidItStickException(message: 'Card not found.');
    }
    return CardService.view(session, card);
  }

  /// Accepts a batch of marks, typically a phone's offline queue. Resending
  /// is safe. Returns the clientMarkIds the server holds.
  Future<List<String>> syncMarks(Session session, List<MarkInput> marks) async {
    final member = await FamilyService.requireMember(session);
    if (marks.length > 100) {
      throw DidItStickException(message: 'Too many marks at once.');
    }
    return CardService.recordMarks(session, member, marks);
  }
}

/// Re-checks, the weekly digest and its share link.
class ProgressEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<WeeklyDigest> digest(Session session) async {
    final member = await FamilyService.requireMember(session);
    return DigestService.weekly(session, member.familyId);
  }

  Future<ShareLink> shareDigest(Session session) async {
    final member = await FamilyService.requireMember(session);
    final family = await Family.db.findById(session, member.familyId);
    var token = family!.shareToken;
    if (token == null) {
      final r = Random.secure();
      token = List.generate(24, (_) => r.nextInt(36).toRadixString(36)).join();
      await Family.db.updateRow(session, family.copyWith(shareToken: token));
    }
    final base = _shareBase(session);
    return ShareLink(url: base == null ? null : '$base/s/$token');
  }

  Future<void> stopSharing(Session session) async {
    final member = await FamilyService.requireMember(session);
    final family = await Family.db.findById(session, member.familyId);
    await Family.db.updateRow(session, family!.copyWith(shareToken: null));
  }

  /// Demo control, labelled as such in the app: runs re-checks due within
  /// [days] right now instead of waiting.
  Future<int> jumpAhead(Session session, int days) async {
    final member = await FamilyService.requireMember(session);
    if (days < 1 || days > 7) {
      throw DidItStickException(message: 'Jump 1 to 7 days.');
    }
    final made = await RecheckService.jumpAhead(session, member.familyId, days);
    if (made == 0) {
      await FamilyService.postEvent(
        session,
        member.familyId,
        kind: 'info',
        message: 'No re-checks due in the next $days days',
      );
    }
    return made;
  }
}
