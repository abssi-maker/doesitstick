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
import 'question_card.dart' as _ijnkpz08;
import 'question_view.dart' as _irhyxwad;

abstract class CardView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CardView._({
    required this.card,
    required this.questions,
    required this.conceptTitle,
    required this.methodName,
    required this.methodLine,
    required this.grade,
  });

  factory CardView({
    required _ijnkpz08.QuestionCard card,
    required List<_irhyxwad.QuestionView> questions,
    required String conceptTitle,
    required String methodName,
    required String methodLine,
    required int grade,
  }) = _CardViewImpl;

  factory CardView.fromJson(Map<String, dynamic> jsonSerialization) {
    return CardView(
      card: _i8gpi5ak.Protocol().deserialize<_ijnkpz08.QuestionCard>(
        jsonSerialization['card'],
      ),
      questions: _i8gpi5ak.Protocol().deserialize<List<_irhyxwad.QuestionView>>(
        jsonSerialization['questions'],
      ),
      conceptTitle: jsonSerialization['conceptTitle'] as String,
      methodName: jsonSerialization['methodName'] as String,
      methodLine: jsonSerialization['methodLine'] as String,
      grade: jsonSerialization['grade'] as int,
    );
  }

  _ijnkpz08.QuestionCard card;

  List<_irhyxwad.QuestionView> questions;

  String conceptTitle;

  String methodName;

  String methodLine;

  int grade;

  /// Returns a shallow copy of this [CardView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CardView copyWith({
    _ijnkpz08.QuestionCard? card,
    List<_irhyxwad.QuestionView>? questions,
    String? conceptTitle,
    String? methodName,
    String? methodLine,
    int? grade,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CardView',
      'card': card.toJson(),
      'questions': questions.toJson(valueToJson: (v) => v.toJson()),
      'conceptTitle': conceptTitle,
      'methodName': methodName,
      'methodLine': methodLine,
      'grade': grade,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CardView',
      'card': card.toJsonForProtocol(),
      'questions': questions.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'conceptTitle': conceptTitle,
      'methodName': methodName,
      'methodLine': methodLine,
      'grade': grade,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _CardViewImpl extends CardView {
  _CardViewImpl({
    required _ijnkpz08.QuestionCard card,
    required List<_irhyxwad.QuestionView> questions,
    required String conceptTitle,
    required String methodName,
    required String methodLine,
    required int grade,
  }) : super._(
         card: card,
         questions: questions,
         conceptTitle: conceptTitle,
         methodName: methodName,
         methodLine: methodLine,
         grade: grade,
       );

  /// Returns a shallow copy of this [CardView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CardView copyWith({
    _ijnkpz08.QuestionCard? card,
    List<_irhyxwad.QuestionView>? questions,
    String? conceptTitle,
    String? methodName,
    String? methodLine,
    int? grade,
  }) {
    return CardView(
      card: card ?? this.card.copyWith(),
      questions:
          questions ?? this.questions.map((e0) => e0.copyWith()).toList(),
      conceptTitle: conceptTitle ?? this.conceptTitle,
      methodName: methodName ?? this.methodName,
      methodLine: methodLine ?? this.methodLine,
      grade: grade ?? this.grade,
    );
  }
}
