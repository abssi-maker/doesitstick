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
import 'concept_id.dart' as _igk9xj07;

abstract class ConceptOption
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ConceptOption._({
    required this.conceptId,
    required this.title,
    required this.grade,
    required this.methodName,
    required this.example,
  });

  factory ConceptOption({
    required _igk9xj07.ConceptId conceptId,
    required String title,
    required int grade,
    required String methodName,
    required String example,
  }) = _ConceptOptionImpl;

  factory ConceptOption.fromJson(Map<String, dynamic> jsonSerialization) {
    return ConceptOption(
      conceptId: _igk9xj07.ConceptId.fromJson(
        (jsonSerialization['conceptId'] as String),
      ),
      title: jsonSerialization['title'] as String,
      grade: jsonSerialization['grade'] as int,
      methodName: jsonSerialization['methodName'] as String,
      example: jsonSerialization['example'] as String,
    );
  }

  _igk9xj07.ConceptId conceptId;

  String title;

  int grade;

  String methodName;

  String example;

  /// Returns a shallow copy of this [ConceptOption]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ConceptOption copyWith({
    _igk9xj07.ConceptId? conceptId,
    String? title,
    int? grade,
    String? methodName,
    String? example,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ConceptOption',
      'conceptId': conceptId.toJson(),
      'title': title,
      'grade': grade,
      'methodName': methodName,
      'example': example,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ConceptOption',
      'conceptId': conceptId.toJson(),
      'title': title,
      'grade': grade,
      'methodName': methodName,
      'example': example,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ConceptOptionImpl extends ConceptOption {
  _ConceptOptionImpl({
    required _igk9xj07.ConceptId conceptId,
    required String title,
    required int grade,
    required String methodName,
    required String example,
  }) : super._(
         conceptId: conceptId,
         title: title,
         grade: grade,
         methodName: methodName,
         example: example,
       );

  /// Returns a shallow copy of this [ConceptOption]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ConceptOption copyWith({
    _igk9xj07.ConceptId? conceptId,
    String? title,
    int? grade,
    String? methodName,
    String? example,
  }) {
    return ConceptOption(
      conceptId: conceptId ?? this.conceptId,
      title: title ?? this.title,
      grade: grade ?? this.grade,
      methodName: methodName ?? this.methodName,
      example: example ?? this.example,
    );
  }
}
