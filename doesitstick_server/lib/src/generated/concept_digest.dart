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
import 'package:doesitstick_server/src/generated/protocol.dart' as _i0djspd0;
import 'package:serverpod/serverpod.dart' as _is;
import 'concept_id.dart' as _igk9xj07;
import 'evidence_item.dart' as _idvtj3i7;

abstract class ConceptDigest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ConceptDigest._({
    required this.conceptId,
    required this.title,
    required this.status,
    required this.reason,
    required this.evidence,
    this.nextRecheckAt,
  });

  factory ConceptDigest({
    required _igk9xj07.ConceptId conceptId,
    required String title,
    required String status,
    required String reason,
    required List<_idvtj3i7.EvidenceItem> evidence,
    DateTime? nextRecheckAt,
  }) = _ConceptDigestImpl;

  factory ConceptDigest.fromJson(Map<String, dynamic> jsonSerialization) {
    return ConceptDigest(
      conceptId: _igk9xj07.ConceptId.fromJson(
        (jsonSerialization['conceptId'] as String),
      ),
      title: jsonSerialization['title'] as String,
      status: jsonSerialization['status'] as String,
      reason: jsonSerialization['reason'] as String,
      evidence: _i0djspd0.Protocol().deserialize<List<_idvtj3i7.EvidenceItem>>(
        jsonSerialization['evidence'],
      ),
      nextRecheckAt: jsonSerialization['nextRecheckAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['nextRecheckAt'],
            ),
    );
  }

  _igk9xj07.ConceptId conceptId;

  String title;

  /// stuck | growing | waiting
  String status;

  String reason;

  List<_idvtj3i7.EvidenceItem> evidence;

  DateTime? nextRecheckAt;

  /// Returns a shallow copy of this [ConceptDigest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ConceptDigest copyWith({
    _igk9xj07.ConceptId? conceptId,
    String? title,
    String? status,
    String? reason,
    List<_idvtj3i7.EvidenceItem>? evidence,
    DateTime? nextRecheckAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ConceptDigest',
      'conceptId': conceptId.toJson(),
      'title': title,
      'status': status,
      'reason': reason,
      'evidence': evidence.toJson(valueToJson: (v) => v.toJson()),
      if (nextRecheckAt != null) 'nextRecheckAt': nextRecheckAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ConceptDigest',
      'conceptId': conceptId.toJson(),
      'title': title,
      'status': status,
      'reason': reason,
      'evidence': evidence.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (nextRecheckAt != null) 'nextRecheckAt': nextRecheckAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ConceptDigestImpl extends ConceptDigest {
  _ConceptDigestImpl({
    required _igk9xj07.ConceptId conceptId,
    required String title,
    required String status,
    required String reason,
    required List<_idvtj3i7.EvidenceItem> evidence,
    DateTime? nextRecheckAt,
  }) : super._(
         conceptId: conceptId,
         title: title,
         status: status,
         reason: reason,
         evidence: evidence,
         nextRecheckAt: nextRecheckAt,
       );

  /// Returns a shallow copy of this [ConceptDigest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ConceptDigest copyWith({
    _igk9xj07.ConceptId? conceptId,
    String? title,
    String? status,
    String? reason,
    List<_idvtj3i7.EvidenceItem>? evidence,
    Object? nextRecheckAt = _Undefined,
  }) {
    return ConceptDigest(
      conceptId: conceptId ?? this.conceptId,
      title: title ?? this.title,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      evidence: evidence ?? this.evidence.map((e0) => e0.copyWith()).toList(),
      nextRecheckAt: nextRecheckAt is DateTime?
          ? nextRecheckAt
          : this.nextRecheckAt,
    );
  }
}
