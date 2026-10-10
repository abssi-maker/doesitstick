/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:doesitstick_client/src/protocol/protocol.dart' as _i8gpi5ak;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'concept_id.dart' as _igk9xj07;
import 'worksheet_status.dart' as _i3lw21mu;

/// A photographed worksheet and its trip through the background reader.
abstract class Worksheet
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Worksheet._({
    this.id,
    required this.familyId,
    required this.uploadedByName,
    required this.status,
    this.conceptId,
    this.detectedProblems,
    this.note,
    this.cardId,
    this.photoDeletedAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Worksheet({
    int? id,
    required int familyId,
    required String uploadedByName,
    required _i3lw21mu.WorksheetStatus status,
    _igk9xj07.ConceptId? conceptId,
    List<String>? detectedProblems,
    String? note,
    int? cardId,
    DateTime? photoDeletedAt,
    DateTime? createdAt,
  }) = _WorksheetImpl;

  factory Worksheet.fromJson(Map<String, dynamic> jsonSerialization) {
    return Worksheet(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int,
      uploadedByName: jsonSerialization['uploadedByName'] as String,
      status: _i3lw21mu.WorksheetStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      conceptId: jsonSerialization['conceptId'] == null
          ? null
          : _igk9xj07.ConceptId.fromJson(
              (jsonSerialization['conceptId'] as String),
            ),
      detectedProblems: jsonSerialization['detectedProblems'] == null
          ? null
          : _i8gpi5ak.Protocol().deserialize<List<String>>(
              jsonSerialization['detectedProblems'],
            ),
      note: jsonSerialization['note'] as String?,
      cardId: jsonSerialization['cardId'] as int?,
      photoDeletedAt: jsonSerialization['photoDeletedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['photoDeletedAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int familyId;

  String uploadedByName;

  _i3lw21mu.WorksheetStatus status;

  _igk9xj07.ConceptId? conceptId;

  /// Problems the reader saw, e.g. "46 x 7". Shown so the parent can confirm.
  List<String>? detectedProblems;

  String? note;

  int? cardId;

  DateTime? photoDeletedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [Worksheet]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Worksheet copyWith({
    int? id,
    int? familyId,
    String? uploadedByName,
    _i3lw21mu.WorksheetStatus? status,
    _igk9xj07.ConceptId? conceptId,
    List<String>? detectedProblems,
    String? note,
    int? cardId,
    DateTime? photoDeletedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Worksheet',
      if (id != null) 'id': id,
      'familyId': familyId,
      'uploadedByName': uploadedByName,
      'status': status.toJson(),
      if (conceptId != null) 'conceptId': conceptId?.toJson(),
      if (detectedProblems != null)
        'detectedProblems': detectedProblems?.toJson(),
      if (note != null) 'note': note,
      if (cardId != null) 'cardId': cardId,
      if (photoDeletedAt != null) 'photoDeletedAt': photoDeletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Worksheet',
      if (id != null) 'id': id,
      'familyId': familyId,
      'uploadedByName': uploadedByName,
      'status': status.toJson(),
      if (conceptId != null) 'conceptId': conceptId?.toJson(),
      if (detectedProblems != null)
        'detectedProblems': detectedProblems?.toJson(),
      if (note != null) 'note': note,
      if (cardId != null) 'cardId': cardId,
      if (photoDeletedAt != null) 'photoDeletedAt': photoDeletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorksheetImpl extends Worksheet {
  _WorksheetImpl({
    int? id,
    required int familyId,
    required String uploadedByName,
    required _i3lw21mu.WorksheetStatus status,
    _igk9xj07.ConceptId? conceptId,
    List<String>? detectedProblems,
    String? note,
    int? cardId,
    DateTime? photoDeletedAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         familyId: familyId,
         uploadedByName: uploadedByName,
         status: status,
         conceptId: conceptId,
         detectedProblems: detectedProblems,
         note: note,
         cardId: cardId,
         photoDeletedAt: photoDeletedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Worksheet]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Worksheet copyWith({
    Object? id = _Undefined,
    int? familyId,
    String? uploadedByName,
    _i3lw21mu.WorksheetStatus? status,
    Object? conceptId = _Undefined,
    Object? detectedProblems = _Undefined,
    Object? note = _Undefined,
    Object? cardId = _Undefined,
    Object? photoDeletedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return Worksheet(
      id: id is int? ? id : this.id,
      familyId: familyId ?? this.familyId,
      uploadedByName: uploadedByName ?? this.uploadedByName,
      status: status ?? this.status,
      conceptId: conceptId is _igk9xj07.ConceptId? ? conceptId : this.conceptId,
      detectedProblems: detectedProblems is List<String>?
          ? detectedProblems
          : this.detectedProblems?.map((e0) => e0).toList(),
      note: note is String? ? note : this.note,
      cardId: cardId is int? ? cardId : this.cardId,
      photoDeletedAt: photoDeletedAt is DateTime?
          ? photoDeletedAt
          : this.photoDeletedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
