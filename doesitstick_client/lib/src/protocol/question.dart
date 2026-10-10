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
import 'concept_id.dart' as _igk9xj07;
import 'question_style.dart' as _i323tk66;

/// One question to ask out loud. Every number in it was produced and
/// re-checked by server code before the card was published.
abstract class Question
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Question._({
    this.id,
    required this.cardId,
    required this.familyId,
    required this.position,
    required this.conceptId,
    required this.style,
    required this.seed,
    required this.operands,
    required this.prompt,
    required this.expectedAnswer,
    required this.answerValue,
    this.shownWrong,
    required this.methodNote,
    required this.listenFor,
    required this.hint,
    required this.checkedByCode,
    this.variantOfQuestionId,
  });

  factory Question({
    int? id,
    required int cardId,
    required int familyId,
    required int position,
    required _igk9xj07.ConceptId conceptId,
    required _i323tk66.QuestionStyle style,
    required int seed,
    required List<int> operands,
    required String prompt,
    required String expectedAnswer,
    required int answerValue,
    int? shownWrong,
    required String methodNote,
    required String listenFor,
    required String hint,
    required bool checkedByCode,
    int? variantOfQuestionId,
  }) = _QuestionImpl;

  factory Question.fromJson(Map<String, dynamic> jsonSerialization) {
    return Question(
      id: jsonSerialization['id'] as int?,
      cardId: jsonSerialization['cardId'] as int,
      familyId: jsonSerialization['familyId'] as int,
      position: jsonSerialization['position'] as int,
      conceptId: _igk9xj07.ConceptId.fromJson(
        (jsonSerialization['conceptId'] as String),
      ),
      style: _i323tk66.QuestionStyle.fromJson(
        (jsonSerialization['style'] as String),
      ),
      seed: jsonSerialization['seed'] as int,
      operands: _i8gpi5ak.Protocol().deserialize<List<int>>(
        jsonSerialization['operands'],
      ),
      prompt: jsonSerialization['prompt'] as String,
      expectedAnswer: jsonSerialization['expectedAnswer'] as String,
      answerValue: jsonSerialization['answerValue'] as int,
      shownWrong: jsonSerialization['shownWrong'] as int?,
      methodNote: jsonSerialization['methodNote'] as String,
      listenFor: jsonSerialization['listenFor'] as String,
      hint: jsonSerialization['hint'] as String,
      checkedByCode: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['checkedByCode'],
      ),
      variantOfQuestionId: jsonSerialization['variantOfQuestionId'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int cardId;

  int familyId;

  int position;

  _igk9xj07.ConceptId conceptId;

  _i323tk66.QuestionStyle style;

  int seed;

  List<int> operands;

  String prompt;

  String expectedAnswer;

  int answerValue;

  int? shownWrong;

  String methodNote;

  String listenFor;

  String hint;

  bool checkedByCode;

  /// Set on re-check questions: the question this is a new variant of.
  int? variantOfQuestionId;

  /// Returns a shallow copy of this [Question]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Question copyWith({
    int? id,
    int? cardId,
    int? familyId,
    int? position,
    _igk9xj07.ConceptId? conceptId,
    _i323tk66.QuestionStyle? style,
    int? seed,
    List<int>? operands,
    String? prompt,
    String? expectedAnswer,
    int? answerValue,
    int? shownWrong,
    String? methodNote,
    String? listenFor,
    String? hint,
    bool? checkedByCode,
    int? variantOfQuestionId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Question',
      if (id != null) 'id': id,
      'cardId': cardId,
      'familyId': familyId,
      'position': position,
      'conceptId': conceptId.toJson(),
      'style': style.toJson(),
      'seed': seed,
      'operands': operands.toJson(),
      'prompt': prompt,
      'expectedAnswer': expectedAnswer,
      'answerValue': answerValue,
      if (shownWrong != null) 'shownWrong': shownWrong,
      'methodNote': methodNote,
      'listenFor': listenFor,
      'hint': hint,
      'checkedByCode': checkedByCode,
      if (variantOfQuestionId != null)
        'variantOfQuestionId': variantOfQuestionId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Question',
      if (id != null) 'id': id,
      'cardId': cardId,
      'familyId': familyId,
      'position': position,
      'conceptId': conceptId.toJson(),
      'style': style.toJson(),
      'seed': seed,
      'operands': operands.toJson(),
      'prompt': prompt,
      'expectedAnswer': expectedAnswer,
      'answerValue': answerValue,
      if (shownWrong != null) 'shownWrong': shownWrong,
      'methodNote': methodNote,
      'listenFor': listenFor,
      'hint': hint,
      'checkedByCode': checkedByCode,
      if (variantOfQuestionId != null)
        'variantOfQuestionId': variantOfQuestionId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QuestionImpl extends Question {
  _QuestionImpl({
    int? id,
    required int cardId,
    required int familyId,
    required int position,
    required _igk9xj07.ConceptId conceptId,
    required _i323tk66.QuestionStyle style,
    required int seed,
    required List<int> operands,
    required String prompt,
    required String expectedAnswer,
    required int answerValue,
    int? shownWrong,
    required String methodNote,
    required String listenFor,
    required String hint,
    required bool checkedByCode,
    int? variantOfQuestionId,
  }) : super._(
         id: id,
         cardId: cardId,
         familyId: familyId,
         position: position,
         conceptId: conceptId,
         style: style,
         seed: seed,
         operands: operands,
         prompt: prompt,
         expectedAnswer: expectedAnswer,
         answerValue: answerValue,
         shownWrong: shownWrong,
         methodNote: methodNote,
         listenFor: listenFor,
         hint: hint,
         checkedByCode: checkedByCode,
         variantOfQuestionId: variantOfQuestionId,
       );

  /// Returns a shallow copy of this [Question]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Question copyWith({
    Object? id = _Undefined,
    int? cardId,
    int? familyId,
    int? position,
    _igk9xj07.ConceptId? conceptId,
    _i323tk66.QuestionStyle? style,
    int? seed,
    List<int>? operands,
    String? prompt,
    String? expectedAnswer,
    int? answerValue,
    Object? shownWrong = _Undefined,
    String? methodNote,
    String? listenFor,
    String? hint,
    bool? checkedByCode,
    Object? variantOfQuestionId = _Undefined,
  }) {
    return Question(
      id: id is int? ? id : this.id,
      cardId: cardId ?? this.cardId,
      familyId: familyId ?? this.familyId,
      position: position ?? this.position,
      conceptId: conceptId ?? this.conceptId,
      style: style ?? this.style,
      seed: seed ?? this.seed,
      operands: operands ?? this.operands.map((e0) => e0).toList(),
      prompt: prompt ?? this.prompt,
      expectedAnswer: expectedAnswer ?? this.expectedAnswer,
      answerValue: answerValue ?? this.answerValue,
      shownWrong: shownWrong is int? ? shownWrong : this.shownWrong,
      methodNote: methodNote ?? this.methodNote,
      listenFor: listenFor ?? this.listenFor,
      hint: hint ?? this.hint,
      checkedByCode: checkedByCode ?? this.checkedByCode,
      variantOfQuestionId: variantOfQuestionId is int?
          ? variantOfQuestionId
          : this.variantOfQuestionId,
    );
  }
}
