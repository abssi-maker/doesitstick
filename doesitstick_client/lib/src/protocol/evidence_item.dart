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
import 'question_style.dart' as _i323tk66;

abstract class EvidenceItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  EvidenceItem._({
    required this.at,
    required this.recheckDay,
    required this.style,
    required this.outcome,
    required this.parentName,
  });

  factory EvidenceItem({
    required DateTime at,
    required int recheckDay,
    required _i323tk66.QuestionStyle style,
    required _i76t1xe4.Outcome outcome,
    required String parentName,
  }) = _EvidenceItemImpl;

  factory EvidenceItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return EvidenceItem(
      at: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
      recheckDay: jsonSerialization['recheckDay'] as int,
      style: _i323tk66.QuestionStyle.fromJson(
        (jsonSerialization['style'] as String),
      ),
      outcome: _i76t1xe4.Outcome.fromJson(
        (jsonSerialization['outcome'] as String),
      ),
      parentName: jsonSerialization['parentName'] as String,
    );
  }

  DateTime at;

  int recheckDay;

  _i323tk66.QuestionStyle style;

  _i76t1xe4.Outcome outcome;

  String parentName;

  /// Returns a shallow copy of this [EvidenceItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EvidenceItem copyWith({
    DateTime? at,
    int? recheckDay,
    _i323tk66.QuestionStyle? style,
    _i76t1xe4.Outcome? outcome,
    String? parentName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EvidenceItem',
      'at': at.toJson(),
      'recheckDay': recheckDay,
      'style': style.toJson(),
      'outcome': outcome.toJson(),
      'parentName': parentName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EvidenceItem',
      'at': at.toJson(),
      'recheckDay': recheckDay,
      'style': style.toJson(),
      'outcome': outcome.toJson(),
      'parentName': parentName,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _EvidenceItemImpl extends EvidenceItem {
  _EvidenceItemImpl({
    required DateTime at,
    required int recheckDay,
    required _i323tk66.QuestionStyle style,
    required _i76t1xe4.Outcome outcome,
    required String parentName,
  }) : super._(
         at: at,
         recheckDay: recheckDay,
         style: style,
         outcome: outcome,
         parentName: parentName,
       );

  /// Returns a shallow copy of this [EvidenceItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EvidenceItem copyWith({
    DateTime? at,
    int? recheckDay,
    _i323tk66.QuestionStyle? style,
    _i76t1xe4.Outcome? outcome,
    String? parentName,
  }) {
    return EvidenceItem(
      at: at ?? this.at,
      recheckDay: recheckDay ?? this.recheckDay,
      style: style ?? this.style,
      outcome: outcome ?? this.outcome,
      parentName: parentName ?? this.parentName,
    );
  }
}
