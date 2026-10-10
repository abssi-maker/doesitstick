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

/// A household: up to two parents sharing one child's progress.
abstract class Family
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Family._({
    this.id,
    required this.childName,
    required this.inviteCode,
    this.shareToken,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Family({
    int? id,
    required String childName,
    required String inviteCode,
    String? shareToken,
    DateTime? createdAt,
  }) = _FamilyImpl;

  factory Family.fromJson(Map<String, dynamic> jsonSerialization) {
    return Family(
      id: jsonSerialization['id'] as int?,
      childName: jsonSerialization['childName'] as String,
      inviteCode: jsonSerialization['inviteCode'] as String,
      shareToken: jsonSerialization['shareToken'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String childName;

  String inviteCode;

  /// Set only when a parent shares the weekly page; revocable.
  String? shareToken;

  DateTime createdAt;

  /// Returns a shallow copy of this [Family]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Family copyWith({
    int? id,
    String? childName,
    String? inviteCode,
    String? shareToken,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Family',
      if (id != null) 'id': id,
      'childName': childName,
      'inviteCode': inviteCode,
      if (shareToken != null) 'shareToken': shareToken,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Family',
      if (id != null) 'id': id,
      'childName': childName,
      'inviteCode': inviteCode,
      if (shareToken != null) 'shareToken': shareToken,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FamilyImpl extends Family {
  _FamilyImpl({
    int? id,
    required String childName,
    required String inviteCode,
    String? shareToken,
    DateTime? createdAt,
  }) : super._(
         id: id,
         childName: childName,
         inviteCode: inviteCode,
         shareToken: shareToken,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Family]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Family copyWith({
    Object? id = _Undefined,
    String? childName,
    String? inviteCode,
    Object? shareToken = _Undefined,
    DateTime? createdAt,
  }) {
    return Family(
      id: id is int? ? id : this.id,
      childName: childName ?? this.childName,
      inviteCode: inviteCode ?? this.inviteCode,
      shareToken: shareToken is String? ? shareToken : this.shareToken,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
