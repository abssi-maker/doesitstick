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
import 'concept_id.dart' as _igk9xj07;
import 'question_style.dart' as _i323tk66;

/// One question to ask out loud. Every number in it was produced and
/// re-checked by server code before the card was published.
abstract class Question
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
      operands: _i0djspd0.Protocol().deserialize<List<int>>(
        jsonSerialization['operands'],
      ),
      prompt: jsonSerialization['prompt'] as String,
      expectedAnswer: jsonSerialization['expectedAnswer'] as String,
      answerValue: jsonSerialization['answerValue'] as int,
      shownWrong: jsonSerialization['shownWrong'] as int?,
      methodNote: jsonSerialization['methodNote'] as String,
      listenFor: jsonSerialization['listenFor'] as String,
      hint: jsonSerialization['hint'] as String,
      checkedByCode: _is.BoolJsonExtension.fromJson(
        jsonSerialization['checkedByCode'],
      ),
      variantOfQuestionId: jsonSerialization['variantOfQuestionId'] as int?,
    );
  }

  static final t = QuestionTable();

  static const db = QuestionRepository._();

  @override
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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Question]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static QuestionInclude include() {
    return QuestionInclude._();
  }

  static QuestionIncludeList includeList({
    _is.WhereExpressionBuilder<QuestionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<QuestionTable>? orderBy,
    _is.OrderByListBuilder<QuestionTable>? orderByList,
    QuestionInclude? include,
  }) {
    return QuestionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Question.t),
      orderByList: orderByList?.call(Question.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class QuestionUpdateTable extends _is.UpdateTable<QuestionTable> {
  QuestionUpdateTable(super.table);

  _is.ColumnValue<int, int> cardId(int value) => _is.ColumnValue(
    table.cardId,
    value,
  );

  _is.ColumnValue<int, int> familyId(int value) => _is.ColumnValue(
    table.familyId,
    value,
  );

  _is.ColumnValue<int, int> position(int value) => _is.ColumnValue(
    table.position,
    value,
  );

  _is.ColumnValue<_igk9xj07.ConceptId, _igk9xj07.ConceptId> conceptId(
    _igk9xj07.ConceptId value,
  ) => _is.ColumnValue(
    table.conceptId,
    value,
  );

  _is.ColumnValue<_i323tk66.QuestionStyle, _i323tk66.QuestionStyle> style(
    _i323tk66.QuestionStyle value,
  ) => _is.ColumnValue(
    table.style,
    value,
  );

  _is.ColumnValue<int, int> seed(int value) => _is.ColumnValue(
    table.seed,
    value,
  );

  _is.ColumnValue<List<int>, List<int>> operands(List<int> value) =>
      _is.ColumnValue(
        table.operands,
        value,
      );

  _is.ColumnValue<String, String> prompt(String value) => _is.ColumnValue(
    table.prompt,
    value,
  );

  _is.ColumnValue<String, String> expectedAnswer(String value) =>
      _is.ColumnValue(
        table.expectedAnswer,
        value,
      );

  _is.ColumnValue<int, int> answerValue(int value) => _is.ColumnValue(
    table.answerValue,
    value,
  );

  _is.ColumnValue<int, int> shownWrong(int? value) => _is.ColumnValue(
    table.shownWrong,
    value,
  );

  _is.ColumnValue<String, String> methodNote(String value) => _is.ColumnValue(
    table.methodNote,
    value,
  );

  _is.ColumnValue<String, String> listenFor(String value) => _is.ColumnValue(
    table.listenFor,
    value,
  );

  _is.ColumnValue<String, String> hint(String value) => _is.ColumnValue(
    table.hint,
    value,
  );

  _is.ColumnValue<bool, bool> checkedByCode(bool value) => _is.ColumnValue(
    table.checkedByCode,
    value,
  );

  _is.ColumnValue<int, int> variantOfQuestionId(int? value) => _is.ColumnValue(
    table.variantOfQuestionId,
    value,
  );
}

class QuestionTable extends _is.Table<int?> {
  QuestionTable({super.tableRelation}) : super(tableName: 'question') {
    updateTable = QuestionUpdateTable(this);
    cardId = _is.ColumnInt(
      'cardId',
      this,
    );
    familyId = _is.ColumnInt(
      'familyId',
      this,
    );
    position = _is.ColumnInt(
      'position',
      this,
    );
    conceptId = _is.ColumnEnum(
      'conceptId',
      this,
      _is.EnumSerialization.byName,
    );
    style = _is.ColumnEnum(
      'style',
      this,
      _is.EnumSerialization.byName,
    );
    seed = _is.ColumnInt(
      'seed',
      this,
    );
    operands = _is.ColumnSerializable<List<int>>(
      'operands',
      this,
    );
    prompt = _is.ColumnString(
      'prompt',
      this,
    );
    expectedAnswer = _is.ColumnString(
      'expectedAnswer',
      this,
    );
    answerValue = _is.ColumnInt(
      'answerValue',
      this,
    );
    shownWrong = _is.ColumnInt(
      'shownWrong',
      this,
    );
    methodNote = _is.ColumnString(
      'methodNote',
      this,
    );
    listenFor = _is.ColumnString(
      'listenFor',
      this,
    );
    hint = _is.ColumnString(
      'hint',
      this,
    );
    checkedByCode = _is.ColumnBool(
      'checkedByCode',
      this,
    );
    variantOfQuestionId = _is.ColumnInt(
      'variantOfQuestionId',
      this,
    );
  }

  late final QuestionUpdateTable updateTable;

  late final _is.ColumnInt cardId;

  late final _is.ColumnInt familyId;

  late final _is.ColumnInt position;

  late final _is.ColumnEnum<_igk9xj07.ConceptId> conceptId;

  late final _is.ColumnEnum<_i323tk66.QuestionStyle> style;

  late final _is.ColumnInt seed;

  late final _is.ColumnSerializable<List<int>> operands;

  late final _is.ColumnString prompt;

  late final _is.ColumnString expectedAnswer;

  late final _is.ColumnInt answerValue;

  late final _is.ColumnInt shownWrong;

  late final _is.ColumnString methodNote;

  late final _is.ColumnString listenFor;

  late final _is.ColumnString hint;

  late final _is.ColumnBool checkedByCode;

  /// Set on re-check questions: the question this is a new variant of.
  late final _is.ColumnInt variantOfQuestionId;

  @override
  List<_is.Column> get columns => [
    id,
    cardId,
    familyId,
    position,
    conceptId,
    style,
    seed,
    operands,
    prompt,
    expectedAnswer,
    answerValue,
    shownWrong,
    methodNote,
    listenFor,
    hint,
    checkedByCode,
    variantOfQuestionId,
  ];
}

class QuestionInclude extends _is.IncludeObject {
  QuestionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Question.t;
}

class QuestionIncludeList extends _is.IncludeList {
  QuestionIncludeList._({
    _is.WhereExpressionBuilder<QuestionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Question.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Question.t;
}

class QuestionRepository {
  const QuestionRepository._();

  /// Returns a list of [Question]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Question>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<QuestionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<QuestionTable>? orderBy,
    _is.OrderByListBuilder<QuestionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Question>(
      where: where?.call(Question.t),
      orderBy: orderBy?.call(Question.t),
      orderByList: orderByList?.call(Question.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Question] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Question?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<QuestionTable>? where,
    int? offset,
    _is.OrderByBuilder<QuestionTable>? orderBy,
    _is.OrderByListBuilder<QuestionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Question>(
      where: where?.call(Question.t),
      orderBy: orderBy?.call(Question.t),
      orderByList: orderByList?.call(Question.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Question] by its [id] or null if no such row exists.
  Future<Question?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Question>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Question]s in the list and returns the inserted rows.
  ///
  /// The returned [Question]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Question>> insert(
    _is.DatabaseSession session,
    List<Question> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Question>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Question] and returns the inserted row.
  ///
  /// The returned [Question] will have its `id` field set.
  Future<Question> insertRow(
    _is.DatabaseSession session,
    Question row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Question>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Question]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Question]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Question>> upsert(
    _is.DatabaseSession session,
    List<Question> rows, {
    required _is.ColumnSelections<QuestionTable> conflictColumns,
    _is.ColumnSelections<QuestionTable>? updateColumns,
    _is.WhereExpressionBuilder<QuestionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Question>(
      rows,
      conflictColumns: conflictColumns(Question.t),
      updateColumns: updateColumns?.call(Question.t),
      updateWhere: updateWhere?.call(Question.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Question] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Question] will have its `id` field set.
  Future<Question?> upsertRow(
    _is.DatabaseSession session,
    Question row, {
    required _is.ColumnSelections<QuestionTable> conflictColumns,
    _is.ColumnSelections<QuestionTable>? updateColumns,
    _is.WhereExpressionBuilder<QuestionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Question>(
      row,
      conflictColumns: conflictColumns(Question.t),
      updateColumns: updateColumns?.call(Question.t),
      updateWhere: updateWhere?.call(Question.t),
      transaction: transaction,
    );
  }

  /// Updates all [Question]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Question>> update(
    _is.DatabaseSession session,
    List<Question> rows, {
    _is.ColumnSelections<QuestionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Question>(
      rows,
      columns: columns?.call(Question.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Question]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Question> updateRow(
    _is.DatabaseSession session,
    Question row, {
    _is.ColumnSelections<QuestionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Question>(
      row,
      columns: columns?.call(Question.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Question] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Question?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<QuestionUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Question>(
      id,
      columnValues: columnValues(Question.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Question]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Question>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<QuestionUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<QuestionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<QuestionTable>? orderBy,
    _is.OrderByListBuilder<QuestionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Question>(
      columnValues: columnValues(Question.t.updateTable),
      where: where(Question.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Question.t),
      orderByList: orderByList?.call(Question.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Question]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Question>> delete(
    _is.DatabaseSession session,
    List<Question> rows, {
    _is.OrderByBuilder<QuestionTable>? orderBy,
    _is.OrderByListBuilder<QuestionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Question>(
      rows,
      orderBy: orderBy?.call(Question.t),
      orderByList: orderByList?.call(Question.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Question].
  Future<Question> deleteRow(
    _is.DatabaseSession session,
    Question row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Question>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Question>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<QuestionTable> where,
    _is.OrderByBuilder<QuestionTable>? orderBy,
    _is.OrderByListBuilder<QuestionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Question>(
      where: where(Question.t),
      orderBy: orderBy?.call(Question.t),
      orderByList: orderByList?.call(Question.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<QuestionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Question>(
      where: where?.call(Question.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Question] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<QuestionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Question>(
      where: where(Question.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
