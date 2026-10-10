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
import 'mark.dart' as _i5z4rsow;
import 'question.dart' as _in6mynjk;

abstract class QuestionView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  QuestionView._({
    required this.question,
    required this.marks,
    this.latest,
  });

  factory QuestionView({
    required _in6mynjk.Question question,
    required List<_i5z4rsow.Mark> marks,
    _i5z4rsow.Mark? latest,
  }) = _QuestionViewImpl;

  factory QuestionView.fromJson(Map<String, dynamic> jsonSerialization) {
    return QuestionView(
      question: _i0djspd0.Protocol().deserialize<_in6mynjk.Question>(
        jsonSerialization['question'],
      ),
      marks: _i0djspd0.Protocol().deserialize<List<_i5z4rsow.Mark>>(
        jsonSerialization['marks'],
      ),
      latest: jsonSerialization['latest'] == null
          ? null
          : _i0djspd0.Protocol().deserialize<_i5z4rsow.Mark>(
              jsonSerialization['latest'],
            ),
    );
  }

  _in6mynjk.Question question;

  List<_i5z4rsow.Mark> marks;

  /// Latest mark by markedAt across both parents.
  _i5z4rsow.Mark? latest;

  /// Returns a shallow copy of this [QuestionView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  QuestionView copyWith({
    _in6mynjk.Question? question,
    List<_i5z4rsow.Mark>? marks,
    _i5z4rsow.Mark? latest,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QuestionView',
      'question': question.toJson(),
      'marks': marks.toJson(valueToJson: (v) => v.toJson()),
      if (latest != null) 'latest': latest?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QuestionView',
      'question': question.toJsonForProtocol(),
      'marks': marks.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (latest != null) 'latest': latest?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QuestionViewImpl extends QuestionView {
  _QuestionViewImpl({
    required _in6mynjk.Question question,
    required List<_i5z4rsow.Mark> marks,
    _i5z4rsow.Mark? latest,
  }) : super._(
         question: question,
         marks: marks,
         latest: latest,
       );

  /// Returns a shallow copy of this [QuestionView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  QuestionView copyWith({
    _in6mynjk.Question? question,
    List<_i5z4rsow.Mark>? marks,
    Object? latest = _Undefined,
  }) {
    return QuestionView(
      question: question ?? this.question.copyWith(),
      marks: marks ?? this.marks.map((e0) => e0.copyWith()).toList(),
      latest: latest is _i5z4rsow.Mark? ? latest : this.latest?.copyWith(),
    );
  }
}
