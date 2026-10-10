import 'dart:math';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import 'cards/card_service.dart';
import 'digest/digest_service.dart';
import 'family/family_service.dart';
import 'generated/future_calls.dart';
import 'generated/protocol.dart';
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
    await session.serverpod.futureCalls
        .callWithDelay(Duration.zero, identifier: 'worksheet-$worksheetId')
        .readWorksheet
        .read(worksheetId);
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
