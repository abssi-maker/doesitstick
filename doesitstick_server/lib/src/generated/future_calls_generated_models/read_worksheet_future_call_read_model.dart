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

abstract class ReadWorksheetFutureCallReadModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ReadWorksheetFutureCallReadModel._({required this.worksheetId});

  factory ReadWorksheetFutureCallReadModel({required int worksheetId}) =
      _ReadWorksheetFutureCallReadModelImpl;

  factory ReadWorksheetFutureCallReadModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ReadWorksheetFutureCallReadModel(
      worksheetId: jsonSerialization['worksheetId'] as int,
    );
  }

  int worksheetId;

  /// Returns a shallow copy of this [ReadWorksheetFutureCallReadModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReadWorksheetFutureCallReadModel copyWith({int? worksheetId});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReadWorksheetFutureCallReadModel',
      'worksheetId': worksheetId,
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

class _ReadWorksheetFutureCallReadModelImpl
    extends ReadWorksheetFutureCallReadModel {
  _ReadWorksheetFutureCallReadModelImpl({required int worksheetId})
    : super._(worksheetId: worksheetId);

  /// Returns a shallow copy of this [ReadWorksheetFutureCallReadModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReadWorksheetFutureCallReadModel copyWith({int? worksheetId}) {
    return ReadWorksheetFutureCallReadModel(
      worksheetId: worksheetId ?? this.worksheetId,
    );
  }
}
