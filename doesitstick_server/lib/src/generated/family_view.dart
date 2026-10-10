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

abstract class FamilyView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  FamilyView._({
    required this.familyId,
    required this.childName,
    required this.inviteCode,
    required this.me,
    required this.parents,
    this.shareUrl,
  });

  factory FamilyView({
    required int familyId,
    required String childName,
    required String inviteCode,
    required String me,
    required List<String> parents,
    String? shareUrl,
  }) = _FamilyViewImpl;

  factory FamilyView.fromJson(Map<String, dynamic> jsonSerialization) {
    return FamilyView(
      familyId: jsonSerialization['familyId'] as int,
      childName: jsonSerialization['childName'] as String,
      inviteCode: jsonSerialization['inviteCode'] as String,
      me: jsonSerialization['me'] as String,
      parents: _i0djspd0.Protocol().deserialize<List<String>>(
        jsonSerialization['parents'],
      ),
      shareUrl: jsonSerialization['shareUrl'] as String?,
    );
  }

  int familyId;

  String childName;

  String inviteCode;

  String me;

  List<String> parents;

  String? shareUrl;

  /// Returns a shallow copy of this [FamilyView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FamilyView copyWith({
    int? familyId,
    String? childName,
    String? inviteCode,
    String? me,
    List<String>? parents,
    String? shareUrl,
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
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  }) : super._(
         familyId: familyId,
         childName: childName,
         inviteCode: inviteCode,
         me: me,
         parents: parents,
         shareUrl: shareUrl,
       );

  /// Returns a shallow copy of this [FamilyView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FamilyView copyWith({
    int? familyId,
    String? childName,
    String? inviteCode,
    String? me,
    List<String>? parents,
    Object? shareUrl = _Undefined,
  }) {
    return FamilyView(
      familyId: familyId ?? this.familyId,
      childName: childName ?? this.childName,
      inviteCode: inviteCode ?? this.inviteCode,
      me: me ?? this.me,
      parents: parents ?? this.parents.map((e0) => e0).toList(),
      shareUrl: shareUrl is String? ? shareUrl : this.shareUrl,
    );
  }
}
