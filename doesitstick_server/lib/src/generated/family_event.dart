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
import 'package:serverpod/serverpod.dart' as _is;

/// Pushed to both parents' phones over the family stream.
abstract class FamilyEvent
    implements _is.SerializableModel, _is.ProtocolSerialization {
  FamilyEvent._({
    required this.kind,
    required this.message,
    this.actorName,
    this.cardId,
    required this.at,
  });

  factory FamilyEvent({
    required String kind,
    required String message,
    String? actorName,
    int? cardId,
    required DateTime at,
  }) = _FamilyEventImpl;

  factory FamilyEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return FamilyEvent(
      kind: jsonSerialization['kind'] as String,
      message: jsonSerialization['message'] as String,
      actorName: jsonSerialization['actorName'] as String?,
      cardId: jsonSerialization['cardId'] as int?,
      at: _is.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
    );
  }

  String kind;

  String message;

  String? actorName;

  int? cardId;

  DateTime at;

  /// Returns a shallow copy of this [FamilyEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FamilyEvent copyWith({
    String? kind,
    String? message,
    String? actorName,
    int? cardId,
    DateTime? at,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FamilyEvent',
      'kind': kind,
      'message': message,
      if (actorName != null) 'actorName': actorName,
      if (cardId != null) 'cardId': cardId,
      'at': at.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FamilyEvent',
      'kind': kind,
      'message': message,
      if (actorName != null) 'actorName': actorName,
      if (cardId != null) 'cardId': cardId,
      'at': at.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FamilyEventImpl extends FamilyEvent {
  _FamilyEventImpl({
    required String kind,
    required String message,
    String? actorName,
    int? cardId,
    required DateTime at,
  }) : super._(
         kind: kind,
         message: message,
         actorName: actorName,
         cardId: cardId,
         at: at,
       );

  /// Returns a shallow copy of this [FamilyEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FamilyEvent copyWith({
    String? kind,
    String? message,
    Object? actorName = _Undefined,
    Object? cardId = _Undefined,
    DateTime? at,
  }) {
    return FamilyEvent(
      kind: kind ?? this.kind,
      message: message ?? this.message,
      actorName: actorName is String? ? actorName : this.actorName,
      cardId: cardId is int? ? cardId : this.cardId,
      at: at ?? this.at,
    );
  }
}
