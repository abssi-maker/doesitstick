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

abstract class DidItStickException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  DidItStickException._({required this.message});

  factory DidItStickException({required String message}) =
      _DidItStickExceptionImpl;

  factory DidItStickException.fromJson(Map<String, dynamic> jsonSerialization) {
    return DidItStickException(message: jsonSerialization['message'] as String);
  }

  String message;

  /// Returns a shallow copy of this [DidItStickException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DidItStickException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DidItStickException',
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DidItStickException',
      'message': message,
    };
  }

  @override
  String toString() {
    return 'DidItStickException(message: $message)';
  }
}

class _DidItStickExceptionImpl extends DidItStickException {
  _DidItStickExceptionImpl({required String message})
    : super._(message: message);

  /// Returns a shallow copy of this [DidItStickException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DidItStickException copyWith({String? message}) {
    return DidItStickException(message: message ?? this.message);
  }
}
