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
import 'package:serverpod/serverpod.dart' as _is;
import 'card_kind.dart' as _i9emmw3b;
import 'concept_id.dart' as _igk9xj07;

abstract class QuestionCard
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  QuestionCard._({
    this.id,
    required this.familyId,
    required this.conceptId,
    required this.kind,
    required this.recheckDay,
    this.sourceCardId,
    DateTime? createdAt,
    this.completedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory QuestionCard({
    int? id,
    required int familyId,
    required _igk9xj07.ConceptId conceptId,
    required _i9emmw3b.CardKind kind,
    required int recheckDay,
    int? sourceCardId,
    DateTime? createdAt,
    DateTime? completedAt,
  }) = _QuestionCardImpl;

  factory QuestionCard.fromJson(Map<String, dynamic> jsonSerialization) {
    return QuestionCard(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int,
      conceptId: _igk9xj07.ConceptId.fromJson(
        (jsonSerialization['conceptId'] as String),
      ),
      kind: _i9emmw3b.CardKind.fromJson((jsonSerialization['kind'] as String)),
      recheckDay: jsonSerialization['recheckDay'] as int,
      sourceCardId: jsonSerialization['sourceCardId'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
    );
  }

  static final t = QuestionCardTable();

  static const db = QuestionCardRepository._();

  @override
  int? id;

  int familyId;

  _igk9xj07.ConceptId conceptId;

  _i9emmw3b.CardKind kind;

  /// 0 for tonight's card, 2 or 7 for a re-check.
  int recheckDay;

  int? sourceCardId;

  DateTime createdAt;

  DateTime? completedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [QuestionCard]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  QuestionCard copyWith({
    int? id,
    int? familyId,
    _igk9xj07.ConceptId? conceptId,
    _i9emmw3b.CardKind? kind,
    int? recheckDay,
    int? sourceCardId,
    DateTime? createdAt,
    DateTime? completedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QuestionCard',
      if (id != null) 'id': id,
      'familyId': familyId,
      'conceptId': conceptId.toJson(),
      'kind': kind.toJson(),
      'recheckDay': recheckDay,
      if (sourceCardId != null) 'sourceCardId': sourceCardId,
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QuestionCard',
      if (id != null) 'id': id,
      'familyId': familyId,
      'conceptId': conceptId.toJson(),
      'kind': kind.toJson(),
      'recheckDay': recheckDay,
      if (sourceCardId != null) 'sourceCardId': sourceCardId,
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  static QuestionCardInclude include() {
    return QuestionCardInclude._();
  }

  static QuestionCardIncludeList includeList({
    _is.WhereExpressionBuilder<QuestionCardTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<QuestionCardTable>? orderBy,
    _is.OrderByListBuilder<QuestionCardTable>? orderByList,
    QuestionCardInclude? include,
  }) {
    return QuestionCardIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(QuestionCard.t),
      orderByList: orderByList?.call(QuestionCard.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QuestionCardImpl extends QuestionCard {
  _QuestionCardImpl({
    int? id,
    required int familyId,
    required _igk9xj07.ConceptId conceptId,
    required _i9emmw3b.CardKind kind,
    required int recheckDay,
    int? sourceCardId,
    DateTime? createdAt,
    DateTime? completedAt,
  }) : super._(
         id: id,
         familyId: familyId,
         conceptId: conceptId,
         kind: kind,
         recheckDay: recheckDay,
         sourceCardId: sourceCardId,
         createdAt: createdAt,
         completedAt: completedAt,
       );

  /// Returns a shallow copy of this [QuestionCard]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  QuestionCard copyWith({
    Object? id = _Undefined,
    int? familyId,
    _igk9xj07.ConceptId? conceptId,
    _i9emmw3b.CardKind? kind,
    int? recheckDay,
    Object? sourceCardId = _Undefined,
    DateTime? createdAt,
    Object? completedAt = _Undefined,
  }) {
    return QuestionCard(
      id: id is int? ? id : this.id,
      familyId: familyId ?? this.familyId,
      conceptId: conceptId ?? this.conceptId,
      kind: kind ?? this.kind,
      recheckDay: recheckDay ?? this.recheckDay,
      sourceCardId: sourceCardId is int? ? sourceCardId : this.sourceCardId,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
    );
  }
}

class QuestionCardUpdateTable extends _is.UpdateTable<QuestionCardTable> {
  QuestionCardUpdateTable(super.table);

  _is.ColumnValue<int, int> familyId(int value) => _is.ColumnValue(
    table.familyId,
    value,
  );

  _is.ColumnValue<_igk9xj07.ConceptId, _igk9xj07.ConceptId> conceptId(
    _igk9xj07.ConceptId value,
  ) => _is.ColumnValue(
    table.conceptId,
    value,
  );

  _is.ColumnValue<_i9emmw3b.CardKind, _i9emmw3b.CardKind> kind(
    _i9emmw3b.CardKind value,
  ) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<int, int> recheckDay(int value) => _is.ColumnValue(
    table.recheckDay,
    value,
  );

  _is.ColumnValue<int, int> sourceCardId(int? value) => _is.ColumnValue(
    table.sourceCardId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> completedAt(DateTime? value) =>
      _is.ColumnValue(
        table.completedAt,
        value,
      );
}

class QuestionCardTable extends _is.Table<int?> {
  QuestionCardTable({super.tableRelation}) : super(tableName: 'question_card') {
    updateTable = QuestionCardUpdateTable(this);
    familyId = _is.ColumnInt(
      'familyId',
      this,
    );
    conceptId = _is.ColumnEnum(
      'conceptId',
      this,
      _is.EnumSerialization.byName,
    );
    kind = _is.ColumnEnum(
      'kind',
      this,
      _is.EnumSerialization.byName,
    );
    recheckDay = _is.ColumnInt(
      'recheckDay',
      this,
    );
    sourceCardId = _is.ColumnInt(
      'sourceCardId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    completedAt = _is.ColumnDateTime(
      'completedAt',
      this,
    );
  }

  late final QuestionCardUpdateTable updateTable;

  late final _is.ColumnInt familyId;

  late final _is.ColumnEnum<_igk9xj07.ConceptId> conceptId;

  late final _is.ColumnEnum<_i9emmw3b.CardKind> kind;

  /// 0 for tonight's card, 2 or 7 for a re-check.
  late final _is.ColumnInt recheckDay;

  late final _is.ColumnInt sourceCardId;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime completedAt;

  @override
  List<_is.Column> get columns => [
    id,
    familyId,
    conceptId,
    kind,
    recheckDay,
    sourceCardId,
    createdAt,
    completedAt,
  ];
}

class QuestionCardInclude extends _is.IncludeObject {
  QuestionCardInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => QuestionCard.t;
}

class QuestionCardIncludeList extends _is.IncludeList {
  QuestionCardIncludeList._({
    _is.WhereExpressionBuilder<QuestionCardTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(QuestionCard.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => QuestionCard.t;
}

class QuestionCardRepository {
  const QuestionCardRepository._();

  /// Returns a list of [QuestionCard]s matching the given query parameters.
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
  Future<List<QuestionCard>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<QuestionCardTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<QuestionCardTable>? orderBy,
    _is.OrderByListBuilder<QuestionCardTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<QuestionCard>(
      where: where?.call(QuestionCard.t),
      orderBy: orderBy?.call(QuestionCard.t),
      orderByList: orderByList?.call(QuestionCard.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [QuestionCard] matching the given query parameters.
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
  Future<QuestionCard?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<QuestionCardTable>? where,
    int? offset,
    _is.OrderByBuilder<QuestionCardTable>? orderBy,
    _is.OrderByListBuilder<QuestionCardTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<QuestionCard>(
      where: where?.call(QuestionCard.t),
      orderBy: orderBy?.call(QuestionCard.t),
      orderByList: orderByList?.call(QuestionCard.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [QuestionCard] by its [id] or null if no such row exists.
  Future<QuestionCard?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<QuestionCard>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [QuestionCard]s in the list and returns the inserted rows.
  ///
  /// The returned [QuestionCard]s will have their `id` fields set.
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
  Future<List<QuestionCard>> insert(
    _is.DatabaseSession session,
    List<QuestionCard> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<QuestionCard>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [QuestionCard] and returns the inserted row.
  ///
  /// The returned [QuestionCard] will have its `id` field set.
  Future<QuestionCard> insertRow(
    _is.DatabaseSession session,
    QuestionCard row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<QuestionCard>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [QuestionCard]s in the list and returns the resulting rows.
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
  /// The returned [QuestionCard]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<QuestionCard>> upsert(
    _is.DatabaseSession session,
    List<QuestionCard> rows, {
    required _is.ColumnSelections<QuestionCardTable> conflictColumns,
    _is.ColumnSelections<QuestionCardTable>? updateColumns,
    _is.WhereExpressionBuilder<QuestionCardTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<QuestionCard>(
      rows,
      conflictColumns: conflictColumns(QuestionCard.t),
      updateColumns: updateColumns?.call(QuestionCard.t),
      updateWhere: updateWhere?.call(QuestionCard.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [QuestionCard] and returns the resulting row.
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
  /// The returned [QuestionCard] will have its `id` field set.
  Future<QuestionCard?> upsertRow(
    _is.DatabaseSession session,
    QuestionCard row, {
    required _is.ColumnSelections<QuestionCardTable> conflictColumns,
    _is.ColumnSelections<QuestionCardTable>? updateColumns,
    _is.WhereExpressionBuilder<QuestionCardTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<QuestionCard>(
      row,
      conflictColumns: conflictColumns(QuestionCard.t),
      updateColumns: updateColumns?.call(QuestionCard.t),
      updateWhere: updateWhere?.call(QuestionCard.t),
      transaction: transaction,
    );
  }

  /// Updates all [QuestionCard]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<QuestionCard>> update(
    _is.DatabaseSession session,
    List<QuestionCard> rows, {
    _is.ColumnSelections<QuestionCardTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<QuestionCard>(
      rows,
      columns: columns?.call(QuestionCard.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [QuestionCard]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<QuestionCard> updateRow(
    _is.DatabaseSession session,
    QuestionCard row, {
    _is.ColumnSelections<QuestionCardTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<QuestionCard>(
      row,
      columns: columns?.call(QuestionCard.t),
      transaction: transaction,
    );
  }

  /// Updates a single [QuestionCard] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<QuestionCard?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<QuestionCardUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<QuestionCard>(
      id,
      columnValues: columnValues(QuestionCard.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [QuestionCard]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<QuestionCard>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<QuestionCardUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<QuestionCardTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<QuestionCardTable>? orderBy,
    _is.OrderByListBuilder<QuestionCardTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<QuestionCard>(
      columnValues: columnValues(QuestionCard.t.updateTable),
      where: where(QuestionCard.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(QuestionCard.t),
      orderByList: orderByList?.call(QuestionCard.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [QuestionCard]s in the list and returns the deleted rows.
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
  Future<List<QuestionCard>> delete(
    _is.DatabaseSession session,
    List<QuestionCard> rows, {
    _is.OrderByBuilder<QuestionCardTable>? orderBy,
    _is.OrderByListBuilder<QuestionCardTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<QuestionCard>(
      rows,
      orderBy: orderBy?.call(QuestionCard.t),
      orderByList: orderByList?.call(QuestionCard.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [QuestionCard].
  Future<QuestionCard> deleteRow(
    _is.DatabaseSession session,
    QuestionCard row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<QuestionCard>(
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
  Future<List<QuestionCard>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<QuestionCardTable> where,
    _is.OrderByBuilder<QuestionCardTable>? orderBy,
    _is.OrderByListBuilder<QuestionCardTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<QuestionCard>(
      where: where(QuestionCard.t),
      orderBy: orderBy?.call(QuestionCard.t),
      orderByList: orderByList?.call(QuestionCard.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<QuestionCardTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<QuestionCard>(
      where: where?.call(QuestionCard.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [QuestionCard] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<QuestionCardTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<QuestionCard>(
      where: where(QuestionCard.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
