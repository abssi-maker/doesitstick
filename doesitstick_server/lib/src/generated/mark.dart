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
import 'outcome.dart' as _i76t1xe4;

/// A parent's observation. clientMarkId makes offline re-sends idempotent.
abstract class Mark implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Mark._({
    this.id,
    required this.questionId,
    required this.cardId,
    required this.familyId,
    required this.outcome,
    required this.parentName,
    this.authUserId,
    required this.clientMarkId,
    required this.markedAt,
    DateTime? receivedAt,
  }) : receivedAt = receivedAt ?? DateTime.now();

  factory Mark({
    int? id,
    required int questionId,
    required int cardId,
    required int familyId,
    required _i76t1xe4.Outcome outcome,
    required String parentName,
    _is.UuidValue? authUserId,
    required String clientMarkId,
    required DateTime markedAt,
    DateTime? receivedAt,
  }) = _MarkImpl;

  factory Mark.fromJson(Map<String, dynamic> jsonSerialization) {
    return Mark(
      id: jsonSerialization['id'] as int?,
      questionId: jsonSerialization['questionId'] as int,
      cardId: jsonSerialization['cardId'] as int,
      familyId: jsonSerialization['familyId'] as int,
      outcome: _i76t1xe4.Outcome.fromJson(
        (jsonSerialization['outcome'] as String),
      ),
      parentName: jsonSerialization['parentName'] as String,
      authUserId: jsonSerialization['authUserId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['authUserId'],
            ),
      clientMarkId: jsonSerialization['clientMarkId'] as String,
      markedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['markedAt'],
      ),
      receivedAt: jsonSerialization['receivedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['receivedAt']),
    );
  }

  static final t = MarkTable();

  static const db = MarkRepository._();

  @override
  int? id;

  int questionId;

  int cardId;

  int familyId;

  _i76t1xe4.Outcome outcome;

  String parentName;

  _is.UuidValue? authUserId;

  String clientMarkId;

  DateTime markedAt;

  DateTime receivedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Mark]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Mark copyWith({
    int? id,
    int? questionId,
    int? cardId,
    int? familyId,
    _i76t1xe4.Outcome? outcome,
    String? parentName,
    _is.UuidValue? authUserId,
    String? clientMarkId,
    DateTime? markedAt,
    DateTime? receivedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Mark',
      if (id != null) 'id': id,
      'questionId': questionId,
      'cardId': cardId,
      'familyId': familyId,
      'outcome': outcome.toJson(),
      'parentName': parentName,
      if (authUserId != null) 'authUserId': authUserId?.toJson(),
      'clientMarkId': clientMarkId,
      'markedAt': markedAt.toJson(),
      'receivedAt': receivedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Mark',
      if (id != null) 'id': id,
      'questionId': questionId,
      'cardId': cardId,
      'familyId': familyId,
      'outcome': outcome.toJson(),
      'parentName': parentName,
      'clientMarkId': clientMarkId,
      'markedAt': markedAt.toJson(),
      'receivedAt': receivedAt.toJson(),
    };
  }

  static MarkInclude include() {
    return MarkInclude._();
  }

  static MarkIncludeList includeList({
    _is.WhereExpressionBuilder<MarkTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MarkTable>? orderBy,
    _is.OrderByListBuilder<MarkTable>? orderByList,
    MarkInclude? include,
  }) {
    return MarkIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Mark.t),
      orderByList: orderByList?.call(Mark.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MarkImpl extends Mark {
  _MarkImpl({
    int? id,
    required int questionId,
    required int cardId,
    required int familyId,
    required _i76t1xe4.Outcome outcome,
    required String parentName,
    _is.UuidValue? authUserId,
    required String clientMarkId,
    required DateTime markedAt,
    DateTime? receivedAt,
  }) : super._(
         id: id,
         questionId: questionId,
         cardId: cardId,
         familyId: familyId,
         outcome: outcome,
         parentName: parentName,
         authUserId: authUserId,
         clientMarkId: clientMarkId,
         markedAt: markedAt,
         receivedAt: receivedAt,
       );

  /// Returns a shallow copy of this [Mark]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Mark copyWith({
    Object? id = _Undefined,
    int? questionId,
    int? cardId,
    int? familyId,
    _i76t1xe4.Outcome? outcome,
    String? parentName,
    Object? authUserId = _Undefined,
    String? clientMarkId,
    DateTime? markedAt,
    DateTime? receivedAt,
  }) {
    return Mark(
      id: id is int? ? id : this.id,
      questionId: questionId ?? this.questionId,
      cardId: cardId ?? this.cardId,
      familyId: familyId ?? this.familyId,
      outcome: outcome ?? this.outcome,
      parentName: parentName ?? this.parentName,
      authUserId: authUserId is _is.UuidValue? ? authUserId : this.authUserId,
      clientMarkId: clientMarkId ?? this.clientMarkId,
      markedAt: markedAt ?? this.markedAt,
      receivedAt: receivedAt ?? this.receivedAt,
    );
  }
}

class MarkUpdateTable extends _is.UpdateTable<MarkTable> {
  MarkUpdateTable(super.table);

  _is.ColumnValue<int, int> questionId(int value) => _is.ColumnValue(
    table.questionId,
    value,
  );

  _is.ColumnValue<int, int> cardId(int value) => _is.ColumnValue(
    table.cardId,
    value,
  );

  _is.ColumnValue<int, int> familyId(int value) => _is.ColumnValue(
    table.familyId,
    value,
  );

  _is.ColumnValue<_i76t1xe4.Outcome, _i76t1xe4.Outcome> outcome(
    _i76t1xe4.Outcome value,
  ) => _is.ColumnValue(
    table.outcome,
    value,
  );

  _is.ColumnValue<String, String> parentName(String value) => _is.ColumnValue(
    table.parentName,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> clientMarkId(String value) => _is.ColumnValue(
    table.clientMarkId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> markedAt(DateTime value) =>
      _is.ColumnValue(
        table.markedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> receivedAt(DateTime value) =>
      _is.ColumnValue(
        table.receivedAt,
        value,
      );
}

class MarkTable extends _is.Table<int?> {
  MarkTable({super.tableRelation}) : super(tableName: 'mark') {
    updateTable = MarkUpdateTable(this);
    questionId = _is.ColumnInt(
      'questionId',
      this,
    );
    cardId = _is.ColumnInt(
      'cardId',
      this,
    );
    familyId = _is.ColumnInt(
      'familyId',
      this,
    );
    outcome = _is.ColumnEnum(
      'outcome',
      this,
      _is.EnumSerialization.byName,
    );
    parentName = _is.ColumnString(
      'parentName',
      this,
    );
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    clientMarkId = _is.ColumnString(
      'clientMarkId',
      this,
    );
    markedAt = _is.ColumnDateTime(
      'markedAt',
      this,
    );
    receivedAt = _is.ColumnDateTime(
      'receivedAt',
      this,
      hasDefault: true,
    );
  }

  late final MarkUpdateTable updateTable;

  late final _is.ColumnInt questionId;

  late final _is.ColumnInt cardId;

  late final _is.ColumnInt familyId;

  late final _is.ColumnEnum<_i76t1xe4.Outcome> outcome;

  late final _is.ColumnString parentName;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnString clientMarkId;

  late final _is.ColumnDateTime markedAt;

  late final _is.ColumnDateTime receivedAt;

  @override
  List<_is.Column> get columns => [
    id,
    questionId,
    cardId,
    familyId,
    outcome,
    parentName,
    authUserId,
    clientMarkId,
    markedAt,
    receivedAt,
  ];
}

class MarkInclude extends _is.IncludeObject {
  MarkInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Mark.t;
}

class MarkIncludeList extends _is.IncludeList {
  MarkIncludeList._({
    _is.WhereExpressionBuilder<MarkTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Mark.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Mark.t;
}

class MarkRepository {
  const MarkRepository._();

  /// Returns a list of [Mark]s matching the given query parameters.
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
  Future<List<Mark>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MarkTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MarkTable>? orderBy,
    _is.OrderByListBuilder<MarkTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Mark>(
      where: where?.call(Mark.t),
      orderBy: orderBy?.call(Mark.t),
      orderByList: orderByList?.call(Mark.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Mark] matching the given query parameters.
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
  Future<Mark?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MarkTable>? where,
    int? offset,
    _is.OrderByBuilder<MarkTable>? orderBy,
    _is.OrderByListBuilder<MarkTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Mark>(
      where: where?.call(Mark.t),
      orderBy: orderBy?.call(Mark.t),
      orderByList: orderByList?.call(Mark.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Mark] by its [id] or null if no such row exists.
  Future<Mark?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Mark>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Mark]s in the list and returns the inserted rows.
  ///
  /// The returned [Mark]s will have their `id` fields set.
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
  Future<List<Mark>> insert(
    _is.DatabaseSession session,
    List<Mark> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Mark>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Mark] and returns the inserted row.
  ///
  /// The returned [Mark] will have its `id` field set.
  Future<Mark> insertRow(
    _is.DatabaseSession session,
    Mark row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Mark>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Mark]s in the list and returns the resulting rows.
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
  /// The returned [Mark]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Mark>> upsert(
    _is.DatabaseSession session,
    List<Mark> rows, {
    required _is.ColumnSelections<MarkTable> conflictColumns,
    _is.ColumnSelections<MarkTable>? updateColumns,
    _is.WhereExpressionBuilder<MarkTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Mark>(
      rows,
      conflictColumns: conflictColumns(Mark.t),
      updateColumns: updateColumns?.call(Mark.t),
      updateWhere: updateWhere?.call(Mark.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Mark] and returns the resulting row.
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
  /// The returned [Mark] will have its `id` field set.
  Future<Mark?> upsertRow(
    _is.DatabaseSession session,
    Mark row, {
    required _is.ColumnSelections<MarkTable> conflictColumns,
    _is.ColumnSelections<MarkTable>? updateColumns,
    _is.WhereExpressionBuilder<MarkTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Mark>(
      row,
      conflictColumns: conflictColumns(Mark.t),
      updateColumns: updateColumns?.call(Mark.t),
      updateWhere: updateWhere?.call(Mark.t),
      transaction: transaction,
    );
  }

  /// Updates all [Mark]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Mark>> update(
    _is.DatabaseSession session,
    List<Mark> rows, {
    _is.ColumnSelections<MarkTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Mark>(
      rows,
      columns: columns?.call(Mark.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Mark]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Mark> updateRow(
    _is.DatabaseSession session,
    Mark row, {
    _is.ColumnSelections<MarkTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Mark>(
      row,
      columns: columns?.call(Mark.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Mark] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Mark?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<MarkUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Mark>(
      id,
      columnValues: columnValues(Mark.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Mark]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Mark>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<MarkUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<MarkTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MarkTable>? orderBy,
    _is.OrderByListBuilder<MarkTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Mark>(
      columnValues: columnValues(Mark.t.updateTable),
      where: where(Mark.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Mark.t),
      orderByList: orderByList?.call(Mark.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Mark]s in the list and returns the deleted rows.
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
  Future<List<Mark>> delete(
    _is.DatabaseSession session,
    List<Mark> rows, {
    _is.OrderByBuilder<MarkTable>? orderBy,
    _is.OrderByListBuilder<MarkTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Mark>(
      rows,
      orderBy: orderBy?.call(Mark.t),
      orderByList: orderByList?.call(Mark.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Mark].
  Future<Mark> deleteRow(
    _is.DatabaseSession session,
    Mark row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Mark>(
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
  Future<List<Mark>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MarkTable> where,
    _is.OrderByBuilder<MarkTable>? orderBy,
    _is.OrderByListBuilder<MarkTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Mark>(
      where: where(Mark.t),
      orderBy: orderBy?.call(Mark.t),
      orderByList: orderByList?.call(Mark.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MarkTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Mark>(
      where: where?.call(Mark.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Mark] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MarkTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Mark>(
      where: where(Mark.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
