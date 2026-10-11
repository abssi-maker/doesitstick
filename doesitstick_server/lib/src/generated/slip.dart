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

/// A wrong answer children often give for one problem, worked out by code
/// from its numbers: what probably happened, and the question to ask next.
abstract class Slip
    implements _is.SerializableModel, _is.ProtocolSerialization {
  Slip._({
    required this.answer,
    required this.what,
    required this.ask,
  });

  factory Slip({
    required int answer,
    required String what,
    required String ask,
  }) = _SlipImpl;

  factory Slip.fromJson(Map<String, dynamic> jsonSerialization) {
    return Slip(
      answer: jsonSerialization['answer'] as int,
      what: jsonSerialization['what'] as String,
      ask: jsonSerialization['ask'] as String,
    );
  }

  int answer;

  String what;

  String ask;

  /// Returns a shallow copy of this [Slip]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Slip copyWith({
    int? answer,
    String? what,
    String? ask,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Slip',
      'answer': answer,
      'what': what,
      'ask': ask,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Slip',
      'answer': answer,
      'what': what,
      'ask': ask,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SlipImpl extends Slip {
  _SlipImpl({
    required int answer,
    required String what,
    required String ask,
  }) : super._(
         answer: answer,
         what: what,
         ask: ask,
       );

  /// Returns a shallow copy of this [Slip]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Slip copyWith({
    int? answer,
    String? what,
    String? ask,
  }) {
    return Slip(
      answer: answer ?? this.answer,
      what: what ?? this.what,
      ask: ask ?? this.ask,
    );
  }
}
