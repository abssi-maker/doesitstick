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

abstract class RecheckFutureCallMaterializeModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  RecheckFutureCallMaterializeModel._({required this.recheckId});

  factory RecheckFutureCallMaterializeModel({required int recheckId}) =
      _RecheckFutureCallMaterializeModelImpl;

  factory RecheckFutureCallMaterializeModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RecheckFutureCallMaterializeModel(
      recheckId: jsonSerialization['recheckId'] as int,
    );
  }

  int recheckId;

  /// Returns a shallow copy of this [RecheckFutureCallMaterializeModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RecheckFutureCallMaterializeModel copyWith({int? recheckId});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecheckFutureCallMaterializeModel',
      'recheckId': recheckId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _RecheckFutureCallMaterializeModelImpl
    extends RecheckFutureCallMaterializeModel {
  _RecheckFutureCallMaterializeModelImpl({required int recheckId})
    : super._(recheckId: recheckId);

  /// Returns a shallow copy of this [RecheckFutureCallMaterializeModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RecheckFutureCallMaterializeModel copyWith({int? recheckId}) {
    return RecheckFutureCallMaterializeModel(
      recheckId: recheckId ?? this.recheckId,
    );
  }
}
