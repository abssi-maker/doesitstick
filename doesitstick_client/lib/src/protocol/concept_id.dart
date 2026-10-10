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

/// Grade 3-5 concepts the server can build and check questions for.
enum ConceptId implements _isc.SerializableModel {
  addRegroup,
  subtractCountUp,
  multiply2x1,
  multiply2x2,
  divideByOneDigit,
  equivalentFractions;

  static ConceptId fromJson(String name) {
    switch (name) {
      case 'addRegroup':
        return ConceptId.addRegroup;
      case 'subtractCountUp':
        return ConceptId.subtractCountUp;
      case 'multiply2x1':
        return ConceptId.multiply2x1;
      case 'multiply2x2':
        return ConceptId.multiply2x2;
      case 'divideByOneDigit':
        return ConceptId.divideByOneDigit;
      case 'equivalentFractions':
        return ConceptId.equivalentFractions;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "ConceptId"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
