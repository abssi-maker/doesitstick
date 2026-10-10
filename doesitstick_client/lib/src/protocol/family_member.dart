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

abstract class FamilyMember
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FamilyMember._({
    this.id,
    required this.familyId,
    required this.displayName,
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  factory FamilyMember({
    int? id,
    required int familyId,
    required String displayName,
    DateTime? joinedAt,
  }) = _FamilyMemberImpl;

  factory FamilyMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return FamilyMember(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int,
      displayName: jsonSerialization['displayName'] as String,
      joinedAt: jsonSerialization['joinedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int familyId;

  String displayName;

  DateTime joinedAt;

  /// Returns a shallow copy of this [FamilyMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FamilyMember copyWith({
    int? id,
    int? familyId,
    String? displayName,
    DateTime? joinedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FamilyMember',
      if (id != null) 'id': id,
      'familyId': familyId,
      'displayName': displayName,
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FamilyMember',
      if (id != null) 'id': id,
      'familyId': familyId,
      'displayName': displayName,
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FamilyMemberImpl extends FamilyMember {
  _FamilyMemberImpl({
    int? id,
    required int familyId,
    required String displayName,
    DateTime? joinedAt,
  }) : super._(
         id: id,
         familyId: familyId,
         displayName: displayName,
         joinedAt: joinedAt,
       );

  /// Returns a shallow copy of this [FamilyMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FamilyMember copyWith({
    Object? id = _Undefined,
    int? familyId,
    String? displayName,
    DateTime? joinedAt,
  }) {
    return FamilyMember(
      id: id is int? ? id : this.id,
      familyId: familyId ?? this.familyId,
      displayName: displayName ?? this.displayName,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
