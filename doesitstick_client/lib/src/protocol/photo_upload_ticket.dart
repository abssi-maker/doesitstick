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

abstract class PhotoUploadTicket
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PhotoUploadTicket._({
    required this.worksheetId,
    required this.uploadDescription,
  });

  factory PhotoUploadTicket({
    required int worksheetId,
    required String uploadDescription,
  }) = _PhotoUploadTicketImpl;

  factory PhotoUploadTicket.fromJson(Map<String, dynamic> jsonSerialization) {
    return PhotoUploadTicket(
      worksheetId: jsonSerialization['worksheetId'] as int,
      uploadDescription: jsonSerialization['uploadDescription'] as String,
    );
  }

  int worksheetId;

  String uploadDescription;

  /// Returns a shallow copy of this [PhotoUploadTicket]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PhotoUploadTicket copyWith({
    int? worksheetId,
    String? uploadDescription,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PhotoUploadTicket',
      'worksheetId': worksheetId,
      'uploadDescription': uploadDescription,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PhotoUploadTicket',
      'worksheetId': worksheetId,
      'uploadDescription': uploadDescription,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _PhotoUploadTicketImpl extends PhotoUploadTicket {
  _PhotoUploadTicketImpl({
    required int worksheetId,
    required String uploadDescription,
  }) : super._(
         worksheetId: worksheetId,
         uploadDescription: uploadDescription,
       );

  /// Returns a shallow copy of this [PhotoUploadTicket]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PhotoUploadTicket copyWith({
    int? worksheetId,
    String? uploadDescription,
  }) {
    return PhotoUploadTicket(
      worksheetId: worksheetId ?? this.worksheetId,
      uploadDescription: uploadDescription ?? this.uploadDescription,
    );
  }
}
