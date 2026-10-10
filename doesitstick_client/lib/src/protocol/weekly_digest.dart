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
import 'package:doesitstick_client/src/protocol/protocol.dart' as _i8gpi5ak;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'concept_digest.dart' as _i85n5w8z;

abstract class WeeklyDigest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  WeeklyDigest._({
    required this.childName,
    required this.weekStart,
    required this.weekEnd,
    required this.concepts,
    required this.stuckCount,
    required this.growingCount,
  });

  factory WeeklyDigest({
    required String childName,
    required DateTime weekStart,
    required DateTime weekEnd,
    required List<_i85n5w8z.ConceptDigest> concepts,
    required int stuckCount,
    required int growingCount,
  }) = _WeeklyDigestImpl;

  factory WeeklyDigest.fromJson(Map<String, dynamic> jsonSerialization) {
    return WeeklyDigest(
      childName: jsonSerialization['childName'] as String,
      weekStart: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['weekStart'],
      ),
      weekEnd: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['weekEnd'],
      ),
      concepts: _i8gpi5ak.Protocol().deserialize<List<_i85n5w8z.ConceptDigest>>(
        jsonSerialization['concepts'],
      ),
      stuckCount: jsonSerialization['stuckCount'] as int,
      growingCount: jsonSerialization['growingCount'] as int,
    );
  }

  String childName;

  DateTime weekStart;

  DateTime weekEnd;

  List<_i85n5w8z.ConceptDigest> concepts;

  int stuckCount;

  int growingCount;

  /// Returns a shallow copy of this [WeeklyDigest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  WeeklyDigest copyWith({
    String? childName,
    DateTime? weekStart,
    DateTime? weekEnd,
    List<_i85n5w8z.ConceptDigest>? concepts,
    int? stuckCount,
    int? growingCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WeeklyDigest',
      'childName': childName,
      'weekStart': weekStart.toJson(),
      'weekEnd': weekEnd.toJson(),
      'concepts': concepts.toJson(valueToJson: (v) => v.toJson()),
      'stuckCount': stuckCount,
      'growingCount': growingCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WeeklyDigest',
      'childName': childName,
      'weekStart': weekStart.toJson(),
      'weekEnd': weekEnd.toJson(),
      'concepts': concepts.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'stuckCount': stuckCount,
      'growingCount': growingCount,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _WeeklyDigestImpl extends WeeklyDigest {
  _WeeklyDigestImpl({
    required String childName,
    required DateTime weekStart,
    required DateTime weekEnd,
    required List<_i85n5w8z.ConceptDigest> concepts,
    required int stuckCount,
    required int growingCount,
  }) : super._(
         childName: childName,
         weekStart: weekStart,
         weekEnd: weekEnd,
         concepts: concepts,
         stuckCount: stuckCount,
         growingCount: growingCount,
       );

  /// Returns a shallow copy of this [WeeklyDigest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  WeeklyDigest copyWith({
    String? childName,
    DateTime? weekStart,
    DateTime? weekEnd,
    List<_i85n5w8z.ConceptDigest>? concepts,
    int? stuckCount,
    int? growingCount,
  }) {
    return WeeklyDigest(
      childName: childName ?? this.childName,
      weekStart: weekStart ?? this.weekStart,
      weekEnd: weekEnd ?? this.weekEnd,
      concepts: concepts ?? this.concepts.map((e0) => e0.copyWith()).toList(),
      stuckCount: stuckCount ?? this.stuckCount,
      growingCount: growingCount ?? this.growingCount,
    );
  }
}
