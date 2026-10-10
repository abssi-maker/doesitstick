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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'card_kind.dart' as _i9emmw3b;
import 'concept_id.dart' as _igk9xj07;

abstract class QuestionCard
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  QuestionCard._({
    this.id,
    required this.familyId,
    required this.conceptId,
    required this.kind,
    required this.recheckDay,
    this.sourceCardId,
    DateTime? createdAt,
    this.completedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory QuestionCard({
    int? id,
    required int familyId,
    required _igk9xj07.ConceptId conceptId,
    required _i9emmw3b.CardKind kind,
    required int recheckDay,
    int? sourceCardId,
    DateTime? createdAt,
    DateTime? completedAt,
  }) = _QuestionCardImpl;

  factory QuestionCard.fromJson(Map<String, dynamic> jsonSerialization) {
    return QuestionCard(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int,
      conceptId: _igk9xj07.ConceptId.fromJson(
        (jsonSerialization['conceptId'] as String),
      ),
      kind: _i9emmw3b.CardKind.fromJson((jsonSerialization['kind'] as String)),
      recheckDay: jsonSerialization['recheckDay'] as int,
      sourceCardId: jsonSerialization['sourceCardId'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int familyId;

  _igk9xj07.ConceptId conceptId;

  _i9emmw3b.CardKind kind;

  /// 0 for tonight's card, 2 or 7 for a re-check.
  int recheckDay;

  int? sourceCardId;

  DateTime createdAt;

  DateTime? completedAt;

  /// Returns a shallow copy of this [QuestionCard]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  QuestionCard copyWith({
    int? id,
    int? familyId,
    _igk9xj07.ConceptId? conceptId,
    _i9emmw3b.CardKind? kind,
    int? recheckDay,
    int? sourceCardId,
    DateTime? createdAt,
    DateTime? completedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QuestionCard',
      if (id != null) 'id': id,
      'familyId': familyId,
      'conceptId': conceptId.toJson(),
      'kind': kind.toJson(),
      'recheckDay': recheckDay,
      if (sourceCardId != null) 'sourceCardId': sourceCardId,
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QuestionCard',
      if (id != null) 'id': id,
      'familyId': familyId,
      'conceptId': conceptId.toJson(),
      'kind': kind.toJson(),
      'recheckDay': recheckDay,
      if (sourceCardId != null) 'sourceCardId': sourceCardId,
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QuestionCardImpl extends QuestionCard {
  _QuestionCardImpl({
    int? id,
    required int familyId,
    required _igk9xj07.ConceptId conceptId,
    required _i9emmw3b.CardKind kind,
    required int recheckDay,
    int? sourceCardId,
    DateTime? createdAt,
    DateTime? completedAt,
  }) : super._(
         id: id,
         familyId: familyId,
         conceptId: conceptId,
         kind: kind,
         recheckDay: recheckDay,
         sourceCardId: sourceCardId,
         createdAt: createdAt,
         completedAt: completedAt,
       );

  /// Returns a shallow copy of this [QuestionCard]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  QuestionCard copyWith({
    Object? id = _Undefined,
    int? familyId,
    _igk9xj07.ConceptId? conceptId,
    _i9emmw3b.CardKind? kind,
    int? recheckDay,
    Object? sourceCardId = _Undefined,
    DateTime? createdAt,
    Object? completedAt = _Undefined,
  }) {
    return QuestionCard(
      id: id is int? ? id : this.id,
      familyId: familyId ?? this.familyId,
      conceptId: conceptId ?? this.conceptId,
      kind: kind ?? this.kind,
      recheckDay: recheckDay ?? this.recheckDay,
      sourceCardId: sourceCardId is int? ? sourceCardId : this.sourceCardId,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
    );
  }
}
