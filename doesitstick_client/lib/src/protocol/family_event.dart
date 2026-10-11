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

/// Pushed to both parents' phones over the family stream.
abstract class FamilyEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FamilyEvent._({
    required this.kind,
    required this.message,
    this.actorName,
    this.cardId,
    this.step,
    this.detail,
    required this.at,
  });

  factory FamilyEvent({
    required String kind,
    required String message,
    String? actorName,
    int? cardId,
    int? step,
    String? detail,
    required DateTime at,
  }) = _FamilyEventImpl;

  factory FamilyEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return FamilyEvent(
      kind: jsonSerialization['kind'] as String,
      message: jsonSerialization['message'] as String,
      actorName: jsonSerialization['actorName'] as String?,
      cardId: jsonSerialization['cardId'] as int?,
      step: jsonSerialization['step'] as int?,
      detail: jsonSerialization['detail'] as String?,
      at: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
    );
  }

  String kind;

  String message;

  String? actorName;

  int? cardId;

  /// Presence: the problem the sender is on (0-based) and what they're
  /// doing there (`working`, `hint`, `done`, `following`, or `around` off any card;
  /// `gone` when the app is closed).
  int? step;

  String? detail;

  DateTime at;

  /// Returns a shallow copy of this [FamilyEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FamilyEvent copyWith({
    String? kind,
    String? message,
    String? actorName,
    int? cardId,
    int? step,
    String? detail,
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
      if (step != null) 'step': step,
      if (detail != null) 'detail': detail,
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
      if (step != null) 'step': step,
      if (detail != null) 'detail': detail,
      'at': at.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FamilyEventImpl extends FamilyEvent {
  _FamilyEventImpl({
    required String kind,
    required String message,
    String? actorName,
    int? cardId,
    int? step,
    String? detail,
    required DateTime at,
  }) : super._(
         kind: kind,
         message: message,
         actorName: actorName,
         cardId: cardId,
         step: step,
         detail: detail,
         at: at,
       );

  /// Returns a shallow copy of this [FamilyEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FamilyEvent copyWith({
    String? kind,
    String? message,
    Object? actorName = _Undefined,
    Object? cardId = _Undefined,
    Object? step = _Undefined,
    Object? detail = _Undefined,
    DateTime? at,
  }) {
    return FamilyEvent(
      kind: kind ?? this.kind,
      message: message ?? this.message,
      actorName: actorName is String? ? actorName : this.actorName,
      cardId: cardId is int? ? cardId : this.cardId,
      step: step is int? ? step : this.step,
      detail: detail is String? ? detail : this.detail,
      at: at ?? this.at,
    );
  }
}
