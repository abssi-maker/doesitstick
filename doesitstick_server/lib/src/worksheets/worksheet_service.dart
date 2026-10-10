import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../cards/card_service.dart';
import '../family/family_service.dart';
import '../generated/protocol.dart';
import '../math/concepts.dart';
import 'worksheet_reader.dart';

typedef ReadFn = Future<WorksheetReading> Function(Uint8List image);

/// The background job behind "Photograph worksheet".
class WorksheetService {
  static const storageId = 'private';

  /// Test hook: replaces the Gemini call.
  static ReadFn? readOverride;

  static Future<void> process(Session session, int worksheetId) async {
    final ws = await Worksheet.db.findById(session, worksheetId);
    if (ws == null || ws.status != WorksheetStatus.reading) return;

    final key = WorksheetReader.apiKey(session);
    ReadFn? reader = readOverride;
    if (reader == null && key != null) {
      reader = (image) => WorksheetReader.read(key, image);
    }

    Worksheet result;
    if (reader == null) {
      result = ws.copyWith(
        status: WorksheetStatus.needsTopic,
        note:
            'Automatic reading isn’t switched on for this server yet. '
            'Pick tonight’s topic.',
      );
    } else {
      try {
        final bytes = await session.storage.retrieveFile(
          storageId: storageId,
          path: ws.photoPath!,
        );
        final reading = await reader(
          bytes.buffer.asUint8List(
            bytes.offsetInBytes,
            bytes.lengthInBytes,
          ),
        );
        final concept = reading.concept;
        if (concept != null && reading.confidence != 'low') {
          final card = await CardService.createTonightCard(
            session,
            ws.familyId,
            concept,
            worksheetProblems: reading.problems,
          );
          result = ws.copyWith(
            status: WorksheetStatus.ready,
            conceptId: concept,
            detectedProblems: reading.problems,
            note: reading.note,
            cardId: card.id,
          );
        } else {
          result = ws.copyWith(
            status: WorksheetStatus.needsTopic,
            detectedProblems: reading.problems,
            note: '${reading.note} Pick the closest topic.',
          );
        }
      } catch (e, st) {
        session.log(
          'Worksheet $worksheetId could not be read',
          level: LogLevel.warning,
          exception: e,
          stackTrace: st,
        );
        result = ws.copyWith(
          status: WorksheetStatus.needsTopic,
          note: 'We couldn’t read that photo. Pick the topic instead.',
        );
      }
    }

    // The photo stays (privately, for the family) until the re-check week is
    // over; the maintenance sweep deletes it after [photoKeepDays].
    await Worksheet.db.updateRow(session, result);
    await FamilyService.postEvent(
      session,
      ws.familyId,
      kind: 'worksheet',
      message: result.status == WorksheetStatus.ready
          ? 'New card: ${conceptInfos[result.conceptId]!.title}'
          : 'Worksheet needs a topic',
      actorName: ws.uploadedByName,
      cardId: result.cardId,
    );
  }

  /// Photos are kept for the re-check week so both parents can look at the
  /// worksheet again, then deleted.
  static const photoKeepDays = 7;

  /// Deletes the photo from storage; photoDeletedAt is only set once storage
  /// confirms.
  static Future<Worksheet> deletePhoto(Session session, Worksheet ws) async {
    final path = ws.photoPath;
    if (path == null) return ws;
    try {
      if (await session.storage.fileExists(storageId: storageId, path: path)) {
        await session.storage.deleteFile(storageId: storageId, path: path);
      }
      return ws.copyWith(
        photoPath: null,
        photoDeletedAt: DateTime.now().toUtc(),
      );
    } catch (e) {
      session.log('Photo delete failed for ${ws.id}', level: LogLevel.error);
      return ws;
    }
  }

  /// Parent picked (or corrected) the topic. Replaces an untouched card.
  static Future<Worksheet> chooseTopic(
    Session session,
    FamilyMember member,
    int worksheetId,
    ConceptId concept,
  ) async {
    final ws = await Worksheet.db.findById(session, worksheetId);
    if (ws == null || ws.familyId != member.familyId) {
      throw DidItStickException(message: 'Worksheet not found.');
    }
    final oldCardId = ws.cardId;
    if (oldCardId != null) {
      final marks = await Mark.db.count(
        session,
        where: (t) => t.cardId.equals(oldCardId),
      );
      if (marks > 0) {
        throw DidItStickException(
          message:
              'This card already has answers marked. Snap a new worksheet '
              'to change the topic.',
        );
      }
      await QuestionCard.db.deleteWhere(
        session,
        where: (t) => t.id.equals(oldCardId),
      );
    }
    final card = await CardService.createTonightCard(
      session,
      member.familyId,
      concept,
      worksheetProblems: ws.detectedProblems ?? const [],
    );
    final updated = await Worksheet.db.updateRow(
      session,
      ws.copyWith(
        status: WorksheetStatus.ready,
        conceptId: concept,
        cardId: card.id,
      ),
    );
    await FamilyService.postEvent(
      session,
      member.familyId,
      kind: 'worksheet',
      message: 'New card: ${conceptInfos[concept]!.title}',
      actorName: member.displayName,
      cardId: card.id,
    );
    return updated;
  }
}
