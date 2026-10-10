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
import 'concept_id.dart' as _igk9xj07;
import 'recheck_status.dart' as _ibuccmzf;

/// A scheduled re-check, the durable source of truth behind the future call.
abstract class Recheck
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Recheck._({
    this.id,
    required this.familyId,
    required this.sourceCardId,
    required this.conceptId,
    required this.dayOffset,
    required this.dueAt,
    required this.status,
    this.cardId,
    bool? fastForwarded,
  }) : fastForwarded = fastForwarded ?? false;

  factory Recheck({
    int? id,
    required int familyId,
    required int sourceCardId,
    required _igk9xj07.ConceptId conceptId,
    required int dayOffset,
    required DateTime dueAt,
    required _ibuccmzf.RecheckStatus status,
    int? cardId,
    bool? fastForwarded,
  }) = _RecheckImpl;

  factory Recheck.fromJson(Map<String, dynamic> jsonSerialization) {
    return Recheck(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int,
      sourceCardId: jsonSerialization['sourceCardId'] as int,
      conceptId: _igk9xj07.ConceptId.fromJson(
        (jsonSerialization['conceptId'] as String),
      ),
      dayOffset: jsonSerialization['dayOffset'] as int,
      dueAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      status: _ibuccmzf.RecheckStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      cardId: jsonSerialization['cardId'] as int?,
      fastForwarded: jsonSerialization['fastForwarded'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['fastForwarded']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int familyId;

  int sourceCardId;

  _igk9xj07.ConceptId conceptId;

  int dayOffset;

  DateTime dueAt;

  _ibuccmzf.RecheckStatus status;

  int? cardId;

  /// True when a demo "jump ahead" made it due early.
  bool fastForwarded;

  /// Returns a shallow copy of this [Recheck]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Recheck copyWith({
    int? id,
    int? familyId,
    int? sourceCardId,
    _igk9xj07.ConceptId? conceptId,
    int? dayOffset,
    DateTime? dueAt,
    _ibuccmzf.RecheckStatus? status,
    int? cardId,
    bool? fastForwarded,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Recheck',
      if (id != null) 'id': id,
      'familyId': familyId,
      'sourceCardId': sourceCardId,
      'conceptId': conceptId.toJson(),
      'dayOffset': dayOffset,
      'dueAt': dueAt.toJson(),
      'status': status.toJson(),
      if (cardId != null) 'cardId': cardId,
      'fastForwarded': fastForwarded,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Recheck',
      if (id != null) 'id': id,
      'familyId': familyId,
      'sourceCardId': sourceCardId,
      'conceptId': conceptId.toJson(),
      'dayOffset': dayOffset,
      'dueAt': dueAt.toJson(),
      'status': status.toJson(),
      if (cardId != null) 'cardId': cardId,
      'fastForwarded': fastForwarded,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RecheckImpl extends Recheck {
  _RecheckImpl({
    int? id,
    required int familyId,
    required int sourceCardId,
    required _igk9xj07.ConceptId conceptId,
    required int dayOffset,
    required DateTime dueAt,
    required _ibuccmzf.RecheckStatus status,
    int? cardId,
    bool? fastForwarded,
  }) : super._(
         id: id,
         familyId: familyId,
         sourceCardId: sourceCardId,
         conceptId: conceptId,
         dayOffset: dayOffset,
         dueAt: dueAt,
         status: status,
         cardId: cardId,
         fastForwarded: fastForwarded,
       );

  /// Returns a shallow copy of this [Recheck]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Recheck copyWith({
    Object? id = _Undefined,
    int? familyId,
    int? sourceCardId,
    _igk9xj07.ConceptId? conceptId,
    int? dayOffset,
    DateTime? dueAt,
    _ibuccmzf.RecheckStatus? status,
    Object? cardId = _Undefined,
    bool? fastForwarded,
  }) {
    return Recheck(
      id: id is int? ? id : this.id,
      familyId: familyId ?? this.familyId,
      sourceCardId: sourceCardId ?? this.sourceCardId,
      conceptId: conceptId ?? this.conceptId,
      dayOffset: dayOffset ?? this.dayOffset,
      dueAt: dueAt ?? this.dueAt,
      status: status ?? this.status,
      cardId: cardId is int? ? cardId : this.cardId,
      fastForwarded: fastForwarded ?? this.fastForwarded,
    );
  }
}
