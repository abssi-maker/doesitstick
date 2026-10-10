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
import 'outcome.dart' as _i76t1xe4;

/// Payload sent by the app for each mark, possibly after being queued offline.
abstract class MarkInput
    implements _is.SerializableModel, _is.ProtocolSerialization {
  MarkInput._({
    required this.clientMarkId,
    required this.questionId,
    required this.outcome,
    required this.markedAt,
  });

  factory MarkInput({
    required String clientMarkId,
    required int questionId,
    required _i76t1xe4.Outcome outcome,
    required DateTime markedAt,
  }) = _MarkInputImpl;

  factory MarkInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return MarkInput(
      clientMarkId: jsonSerialization['clientMarkId'] as String,
      questionId: jsonSerialization['questionId'] as int,
      outcome: _i76t1xe4.Outcome.fromJson(
        (jsonSerialization['outcome'] as String),
      ),
      markedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['markedAt'],
      ),
    );
  }

  String clientMarkId;

  int questionId;

  _i76t1xe4.Outcome outcome;

  DateTime markedAt;

  /// Returns a shallow copy of this [MarkInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MarkInput copyWith({
    String? clientMarkId,
    int? questionId,
    _i76t1xe4.Outcome? outcome,
    DateTime? markedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MarkInput',
      'clientMarkId': clientMarkId,
      'questionId': questionId,
      'outcome': outcome.toJson(),
      'markedAt': markedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MarkInput',
      'clientMarkId': clientMarkId,
      'questionId': questionId,
      'outcome': outcome.toJson(),
      'markedAt': markedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _MarkInputImpl extends MarkInput {
  _MarkInputImpl({
    required String clientMarkId,
    required int questionId,
    required _i76t1xe4.Outcome outcome,
    required DateTime markedAt,
  }) : super._(
         clientMarkId: clientMarkId,
         questionId: questionId,
         outcome: outcome,
         markedAt: markedAt,
       );

  /// Returns a shallow copy of this [MarkInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MarkInput copyWith({
    String? clientMarkId,
    int? questionId,
    _i76t1xe4.Outcome? outcome,
    DateTime? markedAt,
  }) {
    return MarkInput(
      clientMarkId: clientMarkId ?? this.clientMarkId,
      questionId: questionId ?? this.questionId,
      outcome: outcome ?? this.outcome,
      markedAt: markedAt ?? this.markedAt,
    );
  }
}
