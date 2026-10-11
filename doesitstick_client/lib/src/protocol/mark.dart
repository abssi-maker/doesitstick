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
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'outcome.dart' as _i76t1xe4;

/// A parent's observation. Synced with Serverpod offline sync inside the
/// family's space: a phone writes it locally, offline if need be, and the
/// UUID id (made on the phone) keeps re-sends idempotent.
abstract class Mark
    implements _isd.TableRow<_isc.UuidValue?>, _isc.ProtocolSerialization {
  Mark._({
    this.id,
    this.spaceId,
    required this.questionId,
    required this.cardId,
    required this.familyId,
    required this.outcome,
    required this.parentName,
    this.authUserId,
    required this.markedAt,
  });

  factory Mark({
    _isc.UuidValue? id,
    int? spaceId,
    required int questionId,
    required int cardId,
    required int familyId,
    required _i76t1xe4.Outcome outcome,
    required String parentName,
    _isc.UuidValue? authUserId,
    required DateTime markedAt,
  }) = _MarkImpl;

  factory Mark.fromJson(Map<String, dynamic> jsonSerialization) {
    return Mark(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      spaceId: jsonSerialization['spaceId'] as int?,
      questionId: jsonSerialization['questionId'] as int,
      cardId: jsonSerialization['cardId'] as int,
      familyId: jsonSerialization['familyId'] as int,
      outcome: _i76t1xe4.Outcome.fromJson(
        (jsonSerialization['outcome'] as String),
      ),
      parentName: jsonSerialization['parentName'] as String,
      authUserId: jsonSerialization['authUserId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['authUserId'],
            ),
      markedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['markedAt'],
      ),
    );
  }

  static final t = MarkTable();

  static const db = MarkRepository._();

  @override
  _isc.UuidValue? id;

  /// The space owning this row. Maintained by the sync engine.
  int? spaceId;

  int questionId;

  int cardId;

  int familyId;

  _i76t1xe4.Outcome outcome;

  String parentName;

  _isc.UuidValue? authUserId;

  DateTime markedAt;

  @override
  _isd.Table<_isc.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Mark]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Mark copyWith({
    _isc.UuidValue? id,
    int? spaceId,
    int? questionId,
    int? cardId,
    int? familyId,
    _i76t1xe4.Outcome? outcome,
    String? parentName,
    _isc.UuidValue? authUserId,
    DateTime? markedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Mark',
      if (id != null) 'id': id?.toJson(),
      if (spaceId != null) 'spaceId': spaceId,
      'questionId': questionId,
      'cardId': cardId,
      'familyId': familyId,
      'outcome': outcome.toJson(),
      'parentName': parentName,
      if (authUserId != null) 'authUserId': authUserId?.toJson(),
      'markedAt': markedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Mark',
      if (id != null) 'id': id?.toJson(),
      if (spaceId != null) 'spaceId': spaceId,
      'questionId': questionId,
      'cardId': cardId,
      'familyId': familyId,
      'outcome': outcome.toJson(),
      'parentName': parentName,
      if (authUserId != null) 'authUserId': authUserId?.toJson(),
      'markedAt': markedAt.toJson(),
    };
  }

  static MarkInclude include() {
    return MarkInclude._();
  }

  static MarkIncludeList includeList({
    _isd.WhereExpressionBuilder<MarkTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<MarkTable>? orderBy,
    _isd.OrderByListBuilder<MarkTable>? orderByList,
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
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MarkImpl extends Mark {
  _MarkImpl({
    _isc.UuidValue? id,
    int? spaceId,
    required int questionId,
    required int cardId,
    required int familyId,
    required _i76t1xe4.Outcome outcome,
    required String parentName,
    _isc.UuidValue? authUserId,
    required DateTime markedAt,
  }) : super._(
         id: id,
         spaceId: spaceId,
         questionId: questionId,
         cardId: cardId,
         familyId: familyId,
         outcome: outcome,
         parentName: parentName,
         authUserId: authUserId,
         markedAt: markedAt,
       );

  /// Returns a shallow copy of this [Mark]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Mark copyWith({
    Object? id = _Undefined,
    Object? spaceId = _Undefined,
    int? questionId,
    int? cardId,
    int? familyId,
    _i76t1xe4.Outcome? outcome,
    String? parentName,
    Object? authUserId = _Undefined,
    DateTime? markedAt,
  }) {
    return Mark(
      id: id is _isc.UuidValue? ? id : this.id,
      spaceId: spaceId is int? ? spaceId : this.spaceId,
      questionId: questionId ?? this.questionId,
      cardId: cardId ?? this.cardId,
      familyId: familyId ?? this.familyId,
      outcome: outcome ?? this.outcome,
      parentName: parentName ?? this.parentName,
      authUserId: authUserId is _isc.UuidValue? ? authUserId : this.authUserId,
      markedAt: markedAt ?? this.markedAt,
    );
  }
}

class MarkUpdateTable extends _isd.UpdateTable<MarkTable> {
  MarkUpdateTable(super.table);

  _isd.ColumnValue<int, int> spaceId(int? value) => _isd.ColumnValue(
    table.spaceId,
    value,
  );

  _isd.ColumnValue<int, int> questionId(int value) => _isd.ColumnValue(
    table.questionId,
    value,
  );

  _isd.ColumnValue<int, int> cardId(int value) => _isd.ColumnValue(
    table.cardId,
    value,
  );

  _isd.ColumnValue<int, int> familyId(int value) => _isd.ColumnValue(
    table.familyId,
    value,
  );

  _isd.ColumnValue<_i76t1xe4.Outcome, _i76t1xe4.Outcome> outcome(
    _i76t1xe4.Outcome value,
  ) => _isd.ColumnValue(
    table.outcome,
    value,
  );

  _isd.ColumnValue<String, String> parentName(String value) => _isd.ColumnValue(
    table.parentName,
    value,
  );

  _isd.ColumnValue<_isc.UuidValue, _isc.UuidValue> authUserId(
    _isc.UuidValue? value,
  ) => _isd.ColumnValue(
    table.authUserId,
    value,
  );

  _isd.ColumnValue<DateTime, DateTime> markedAt(DateTime value) =>
      _isd.ColumnValue(
        table.markedAt,
        value,
      );
}

class MarkTable extends _isd.Table<_isc.UuidValue?> {
  MarkTable({super.tableRelation}) : super(tableName: 'mark') {
    updateTable = MarkUpdateTable(this);
    spaceId = _isd.ColumnInt(
      'spaceId',
      this,
    );
    questionId = _isd.ColumnInt(
      'questionId',
      this,
    );
    cardId = _isd.ColumnInt(
      'cardId',
      this,
    );
    familyId = _isd.ColumnInt(
      'familyId',
      this,
    );
    outcome = _isd.ColumnEnum(
      'outcome',
      this,
      _isd.EnumSerialization.byName,
    );
    parentName = _isd.ColumnString(
      'parentName',
      this,
    );
    authUserId = _isd.ColumnUuid(
      'authUserId',
      this,
    );
    markedAt = _isd.ColumnDateTime(
      'markedAt',
      this,
    );
  }

  late final MarkUpdateTable updateTable;

  /// The space owning this row. Maintained by the sync engine.
  late final _isd.ColumnInt spaceId;

  late final _isd.ColumnInt questionId;

  late final _isd.ColumnInt cardId;

  late final _isd.ColumnInt familyId;

  late final _isd.ColumnEnum<_i76t1xe4.Outcome> outcome;

  late final _isd.ColumnString parentName;

  late final _isd.ColumnUuid authUserId;

  late final _isd.ColumnDateTime markedAt;

  @override
  List<_isd.Column> get columns => [
    id,
    spaceId,
    questionId,
    cardId,
    familyId,
    outcome,
    parentName,
    authUserId,
    markedAt,
  ];
}

class MarkInclude extends _isd.IncludeObject {
  MarkInclude._();

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<_isc.UuidValue?> get table => Mark.t;
}

class MarkIncludeList extends _isd.IncludeList {
  MarkIncludeList._({
    _isd.WhereExpressionBuilder<MarkTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Mark.t);
  }

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<_isc.UuidValue?> get table => Mark.t;
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<MarkTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<MarkTable>? orderBy,
    _isd.OrderByListBuilder<MarkTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<MarkTable>? where,
    int? offset,
    _isd.OrderByBuilder<MarkTable>? orderBy,
    _isd.OrderByListBuilder<MarkTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
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
    _isd.DatabaseSession session,
    _isc.UuidValue id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
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
    _isd.DatabaseSession session,
    List<Mark> rows, {
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    Mark row, {
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    List<Mark> rows, {
    required _isd.ColumnSelections<MarkTable> conflictColumns,
    _isd.ColumnSelections<MarkTable>? updateColumns,
    _isd.WhereExpressionBuilder<MarkTable>? updateWhere,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    Mark row, {
    required _isd.ColumnSelections<MarkTable> conflictColumns,
    _isd.ColumnSelections<MarkTable>? updateColumns,
    _isd.WhereExpressionBuilder<MarkTable>? updateWhere,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    List<Mark> rows, {
    _isd.ColumnSelections<MarkTable>? columns,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    Mark row, {
    _isd.ColumnSelections<MarkTable>? columns,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    _isc.UuidValue id, {
    required _isd.ColumnValueListBuilder<MarkUpdateTable> columnValues,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<MarkUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<MarkTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<MarkTable>? orderBy,
    _isd.OrderByListBuilder<MarkTable>? orderByList,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    List<Mark> rows, {
    _isd.OrderByBuilder<MarkTable>? orderBy,
    _isd.OrderByListBuilder<MarkTable>? orderByList,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    Mark row, {
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<MarkTable> where,
    _isd.OrderByBuilder<MarkTable>? orderBy,
    _isd.OrderByListBuilder<MarkTable>? orderByList,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<MarkTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<Mark>(
      where: where?.call(Mark.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Mark] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<MarkTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Mark>(
      where: where(Mark.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
