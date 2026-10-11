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

abstract class FamilyView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FamilyView._({
    required this.familyId,
    required this.childName,
    required this.inviteCode,
    required this.me,
    required this.parents,
    this.shareUrl,
    this.syncSpace,
  });

  factory FamilyView({
    required int familyId,
    required String childName,
    required String inviteCode,
    required String me,
    required List<String> parents,
    String? shareUrl,
    _isc.UuidValue? syncSpace,
  }) = _FamilyViewImpl;

  factory FamilyView.fromJson(Map<String, dynamic> jsonSerialization) {
    return FamilyView(
      familyId: jsonSerialization['familyId'] as int,
      childName: jsonSerialization['childName'] as String,
      inviteCode: jsonSerialization['inviteCode'] as String,
      me: jsonSerialization['me'] as String,
      parents: _i8gpi5ak.Protocol().deserialize<List<String>>(
        jsonSerialization['parents'],
      ),
      shareUrl: jsonSerialization['shareUrl'] as String?,
      syncSpace: jsonSerialization['syncSpace'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['syncSpace'],
            ),
    );
  }

  int familyId;

  String childName;

  String inviteCode;

  String me;

  List<String> parents;

  String? shareUrl;

  /// The offline sync space this family's marks live in.
  _isc.UuidValue? syncSpace;

  /// Returns a shallow copy of this [FamilyView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FamilyView copyWith({
    int? familyId,
    String? childName,
    String? inviteCode,
    String? me,
    List<String>? parents,
    String? shareUrl,
    _isc.UuidValue? syncSpace,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FamilyView',
      'familyId': familyId,
      'childName': childName,
      'inviteCode': inviteCode,
      'me': me,
      'parents': parents.toJson(),
      if (shareUrl != null) 'shareUrl': shareUrl,
      if (syncSpace != null) 'syncSpace': syncSpace?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FamilyView',
      'familyId': familyId,
      'childName': childName,
      'inviteCode': inviteCode,
      'me': me,
      'parents': parents.toJson(),
      if (shareUrl != null) 'shareUrl': shareUrl,
      if (syncSpace != null) 'syncSpace': syncSpace?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FamilyViewImpl extends FamilyView {
  _FamilyViewImpl({
    required int familyId,
    required String childName,
    required String inviteCode,
    required String me,
    required List<String> parents,
    String? shareUrl,
    _isc.UuidValue? syncSpace,
  }) : super._(
         familyId: familyId,
         childName: childName,
         inviteCode: inviteCode,
         me: me,
         parents: parents,
         shareUrl: shareUrl,
         syncSpace: syncSpace,
       );

  /// Returns a shallow copy of this [FamilyView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FamilyView copyWith({
    int? familyId,
    String? childName,
    String? inviteCode,
    String? me,
    List<String>? parents,
    Object? shareUrl = _Undefined,
    Object? syncSpace = _Undefined,
  }) {
    return FamilyView(
      familyId: familyId ?? this.familyId,
      childName: childName ?? this.childName,
      inviteCode: inviteCode ?? this.inviteCode,
      me: me ?? this.me,
      parents: parents ?? this.parents.map((e0) => e0).toList(),
      shareUrl: shareUrl is String? ? shareUrl : this.shareUrl,
      syncSpace: syncSpace is _isc.UuidValue? ? syncSpace : this.syncSpace,
    );
  }
}
