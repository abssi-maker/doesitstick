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
import 'outcome.dart' as _i76t1xe4;

/// A parent's observation. clientMarkId makes offline re-sends idempotent.
abstract class Mark
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Mark._({
    this.id,
    required this.questionId,
    required this.cardId,
    required this.familyId,
    required this.outcome,
    required this.parentName,
    required this.clientMarkId,
    required this.markedAt,
    DateTime? receivedAt,
  }) : receivedAt = receivedAt ?? DateTime.now();

  factory Mark({
    int? id,
    required int questionId,
    required int cardId,
    required int familyId,
    required _i76t1xe4.Outcome outcome,
    required String parentName,
    required String clientMarkId,
    required DateTime markedAt,
    DateTime? receivedAt,
  }) = _MarkImpl;

  factory Mark.fromJson(Map<String, dynamic> jsonSerialization) {
    return Mark(
      id: jsonSerialization['id'] as int?,
      questionId: jsonSerialization['questionId'] as int,
      cardId: jsonSerialization['cardId'] as int,
      familyId: jsonSerialization['familyId'] as int,
      outcome: _i76t1xe4.Outcome.fromJson(
        (jsonSerialization['outcome'] as String),
      ),
      parentName: jsonSerialization['parentName'] as String,
      clientMarkId: jsonSerialization['clientMarkId'] as String,
      markedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['markedAt'],
      ),
      receivedAt: jsonSerialization['receivedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['receivedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int questionId;

  int cardId;

  int familyId;

  _i76t1xe4.Outcome outcome;

  String parentName;

  String clientMarkId;

  DateTime markedAt;

  DateTime receivedAt;

  /// Returns a shallow copy of this [Mark]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Mark copyWith({
    int? id,
    int? questionId,
    int? cardId,
    int? familyId,
    _i76t1xe4.Outcome? outcome,
    String? parentName,
    String? clientMarkId,
    DateTime? markedAt,
    DateTime? receivedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Mark',
      if (id != null) 'id': id,
      'questionId': questionId,
      'cardId': cardId,
      'familyId': familyId,
      'outcome': outcome.toJson(),
      'parentName': parentName,
      'clientMarkId': clientMarkId,
      'markedAt': markedAt.toJson(),
      'receivedAt': receivedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Mark',
      if (id != null) 'id': id,
      'questionId': questionId,
      'cardId': cardId,
      'familyId': familyId,
      'outcome': outcome.toJson(),
      'parentName': parentName,
      'clientMarkId': clientMarkId,
      'markedAt': markedAt.toJson(),
      'receivedAt': receivedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MarkImpl extends Mark {
  _MarkImpl({
    int? id,
    required int questionId,
    required int cardId,
    required int familyId,
    required _i76t1xe4.Outcome outcome,
    required String parentName,
    required String clientMarkId,
    required DateTime markedAt,
    DateTime? receivedAt,
  }) : super._(
         id: id,
         questionId: questionId,
         cardId: cardId,
         familyId: familyId,
         outcome: outcome,
         parentName: parentName,
         clientMarkId: clientMarkId,
         markedAt: markedAt,
         receivedAt: receivedAt,
       );

  /// Returns a shallow copy of this [Mark]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Mark copyWith({
    Object? id = _Undefined,
    int? questionId,
    int? cardId,
    int? familyId,
    _i76t1xe4.Outcome? outcome,
    String? parentName,
    String? clientMarkId,
    DateTime? markedAt,
    DateTime? receivedAt,
  }) {
    return Mark(
      id: id is int? ? id : this.id,
      questionId: questionId ?? this.questionId,
      cardId: cardId ?? this.cardId,
      familyId: familyId ?? this.familyId,
      outcome: outcome ?? this.outcome,
      parentName: parentName ?? this.parentName,
      clientMarkId: clientMarkId ?? this.clientMarkId,
      markedAt: markedAt ?? this.markedAt,
      receivedAt: receivedAt ?? this.receivedAt,
    );
  }
}
