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
import 'card_view.dart' as _iuaciou8;
import 'family_view.dart' as _i35187xv;
import 'recheck.dart' as _ihmo3v7u;
import 'worksheet.dart' as _itpm72xa;

abstract class HomeState
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  HomeState._({
    required this.family,
    required this.worksheets,
    required this.cards,
    required this.rechecks,
    required this.aiReaderEnabled,
  });

  factory HomeState({
    required _i35187xv.FamilyView family,
    required List<_itpm72xa.Worksheet> worksheets,
    required List<_iuaciou8.CardView> cards,
    required List<_ihmo3v7u.Recheck> rechecks,
    required bool aiReaderEnabled,
  }) = _HomeStateImpl;

  factory HomeState.fromJson(Map<String, dynamic> jsonSerialization) {
    return HomeState(
      family: _i8gpi5ak.Protocol().deserialize<_i35187xv.FamilyView>(
        jsonSerialization['family'],
      ),
      worksheets: _i8gpi5ak.Protocol().deserialize<List<_itpm72xa.Worksheet>>(
        jsonSerialization['worksheets'],
      ),
      cards: _i8gpi5ak.Protocol().deserialize<List<_iuaciou8.CardView>>(
        jsonSerialization['cards'],
      ),
      rechecks: _i8gpi5ak.Protocol().deserialize<List<_ihmo3v7u.Recheck>>(
        jsonSerialization['rechecks'],
      ),
      aiReaderEnabled: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['aiReaderEnabled'],
      ),
    );
  }

  _i35187xv.FamilyView family;

  List<_itpm72xa.Worksheet> worksheets;

  List<_iuaciou8.CardView> cards;

  List<_ihmo3v7u.Recheck> rechecks;

  bool aiReaderEnabled;

  /// Returns a shallow copy of this [HomeState]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  HomeState copyWith({
    _i35187xv.FamilyView? family,
    List<_itpm72xa.Worksheet>? worksheets,
    List<_iuaciou8.CardView>? cards,
    List<_ihmo3v7u.Recheck>? rechecks,
    bool? aiReaderEnabled,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HomeState',
      'family': family.toJson(),
      'worksheets': worksheets.toJson(valueToJson: (v) => v.toJson()),
      'cards': cards.toJson(valueToJson: (v) => v.toJson()),
      'rechecks': rechecks.toJson(valueToJson: (v) => v.toJson()),
      'aiReaderEnabled': aiReaderEnabled,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HomeState',
      'family': family.toJsonForProtocol(),
      'worksheets': worksheets.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'cards': cards.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'rechecks': rechecks.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'aiReaderEnabled': aiReaderEnabled,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _HomeStateImpl extends HomeState {
  _HomeStateImpl({
    required _i35187xv.FamilyView family,
    required List<_itpm72xa.Worksheet> worksheets,
    required List<_iuaciou8.CardView> cards,
    required List<_ihmo3v7u.Recheck> rechecks,
    required bool aiReaderEnabled,
  }) : super._(
         family: family,
         worksheets: worksheets,
         cards: cards,
         rechecks: rechecks,
         aiReaderEnabled: aiReaderEnabled,
       );

  /// Returns a shallow copy of this [HomeState]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  HomeState copyWith({
    _i35187xv.FamilyView? family,
    List<_itpm72xa.Worksheet>? worksheets,
    List<_iuaciou8.CardView>? cards,
    List<_ihmo3v7u.Recheck>? rechecks,
    bool? aiReaderEnabled,
  }) {
    return HomeState(
      family: family ?? this.family.copyWith(),
      worksheets:
          worksheets ?? this.worksheets.map((e0) => e0.copyWith()).toList(),
      cards: cards ?? this.cards.map((e0) => e0.copyWith()).toList(),
      rechecks: rechecks ?? this.rechecks.map((e0) => e0.copyWith()).toList(),
      aiReaderEnabled: aiReaderEnabled ?? this.aiReaderEnabled,
    );
  }
}
