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
import 'concept_id.dart' as _igk9xj07;
import 'recheck_status.dart' as _ibuccmzf;

/// A scheduled re-check, the durable source of truth behind the future call.
abstract class Recheck
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Recheck._({
    this.id,
    required this.familyId,
    required this.sourceCardId,
    required this.conceptId,
    required this.dayOffset,
    required this.dueAt,
    required this.status,
    this.cardId,
    bool? fastForwarded,
  }) : fastForwarded = fastForwarded ?? false;

  factory Recheck({
    int? id,
    required int familyId,
    required int sourceCardId,
    required _igk9xj07.ConceptId conceptId,
    required int dayOffset,
    required DateTime dueAt,
    required _ibuccmzf.RecheckStatus status,
    int? cardId,
    bool? fastForwarded,
  }) = _RecheckImpl;

  factory Recheck.fromJson(Map<String, dynamic> jsonSerialization) {
    return Recheck(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int,
      sourceCardId: jsonSerialization['sourceCardId'] as int,
      conceptId: _igk9xj07.ConceptId.fromJson(
        (jsonSerialization['conceptId'] as String),
      ),
      dayOffset: jsonSerialization['dayOffset'] as int,
      dueAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      status: _ibuccmzf.RecheckStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      cardId: jsonSerialization['cardId'] as int?,
      fastForwarded: jsonSerialization['fastForwarded'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['fastForwarded']),
    );
  }

  static final t = RecheckTable();

  static const db = RecheckRepository._();

  @override
  int? id;

  int familyId;

  int sourceCardId;

  _igk9xj07.ConceptId conceptId;

  int dayOffset;

  DateTime dueAt;

  _ibuccmzf.RecheckStatus status;

  int? cardId;

  /// True when a demo "jump ahead" made it due early.
  bool fastForwarded;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Recheck]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Recheck copyWith({
    int? id,
    int? familyId,
    int? sourceCardId,
    _igk9xj07.ConceptId? conceptId,
    int? dayOffset,
    DateTime? dueAt,
    _ibuccmzf.RecheckStatus? status,
    int? cardId,
    bool? fastForwarded,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Recheck',
      if (id != null) 'id': id,
      'familyId': familyId,
      'sourceCardId': sourceCardId,
      'conceptId': conceptId.toJson(),
      'dayOffset': dayOffset,
      'dueAt': dueAt.toJson(),
      'status': status.toJson(),
      if (cardId != null) 'cardId': cardId,
      'fastForwarded': fastForwarded,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Recheck',
      if (id != null) 'id': id,
      'familyId': familyId,
      'sourceCardId': sourceCardId,
      'conceptId': conceptId.toJson(),
      'dayOffset': dayOffset,
      'dueAt': dueAt.toJson(),
      'status': status.toJson(),
      if (cardId != null) 'cardId': cardId,
      'fastForwarded': fastForwarded,
    };
  }

  static RecheckInclude include() {
    return RecheckInclude._();
  }

  static RecheckIncludeList includeList({
    _is.WhereExpressionBuilder<RecheckTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RecheckTable>? orderBy,
    _is.OrderByListBuilder<RecheckTable>? orderByList,
    RecheckInclude? include,
  }) {
    return RecheckIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Recheck.t),
      orderByList: orderByList?.call(Recheck.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RecheckImpl extends Recheck {
  _RecheckImpl({
    int? id,
    required int familyId,
    required int sourceCardId,
    required _igk9xj07.ConceptId conceptId,
    required int dayOffset,
    required DateTime dueAt,
    required _ibuccmzf.RecheckStatus status,
    int? cardId,
    bool? fastForwarded,
  }) : super._(
         id: id,
         familyId: familyId,
         sourceCardId: sourceCardId,
         conceptId: conceptId,
         dayOffset: dayOffset,
         dueAt: dueAt,
         status: status,
         cardId: cardId,
         fastForwarded: fastForwarded,
       );

  /// Returns a shallow copy of this [Recheck]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Recheck copyWith({
    Object? id = _Undefined,
    int? familyId,
    int? sourceCardId,
    _igk9xj07.ConceptId? conceptId,
    int? dayOffset,
    DateTime? dueAt,
    _ibuccmzf.RecheckStatus? status,
    Object? cardId = _Undefined,
    bool? fastForwarded,
  }) {
    return Recheck(
      id: id is int? ? id : this.id,
      familyId: familyId ?? this.familyId,
      sourceCardId: sourceCardId ?? this.sourceCardId,
      conceptId: conceptId ?? this.conceptId,
      dayOffset: dayOffset ?? this.dayOffset,
      dueAt: dueAt ?? this.dueAt,
      status: status ?? this.status,
      cardId: cardId is int? ? cardId : this.cardId,
      fastForwarded: fastForwarded ?? this.fastForwarded,
    );
  }
}

class RecheckUpdateTable extends _is.UpdateTable<RecheckTable> {
  RecheckUpdateTable(super.table);

  _is.ColumnValue<int, int> familyId(int value) => _is.ColumnValue(
    table.familyId,
    value,
  );

  _is.ColumnValue<int, int> sourceCardId(int value) => _is.ColumnValue(
    table.sourceCardId,
    value,
  );

  _is.ColumnValue<_igk9xj07.ConceptId, _igk9xj07.ConceptId> conceptId(
    _igk9xj07.ConceptId value,
  ) => _is.ColumnValue(
    table.conceptId,
    value,
  );

  _is.ColumnValue<int, int> dayOffset(int value) => _is.ColumnValue(
    table.dayOffset,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> dueAt(DateTime value) => _is.ColumnValue(
    table.dueAt,
    value,
  );

  _is.ColumnValue<_ibuccmzf.RecheckStatus, _ibuccmzf.RecheckStatus> status(
    _ibuccmzf.RecheckStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> cardId(int? value) => _is.ColumnValue(
    table.cardId,
    value,
  );

  _is.ColumnValue<bool, bool> fastForwarded(bool value) => _is.ColumnValue(
    table.fastForwarded,
    value,
  );
}

class RecheckTable extends _is.Table<int?> {
  RecheckTable({super.tableRelation}) : super(tableName: 'recheck') {
    updateTable = RecheckUpdateTable(this);
    familyId = _is.ColumnInt(
      'familyId',
      this,
    );
    sourceCardId = _is.ColumnInt(
      'sourceCardId',
      this,
    );
    conceptId = _is.ColumnEnum(
      'conceptId',
      this,
      _is.EnumSerialization.byName,
    );
    dayOffset = _is.ColumnInt(
      'dayOffset',
      this,
    );
    dueAt = _is.ColumnDateTime(
      'dueAt',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    cardId = _is.ColumnInt(
      'cardId',
      this,
    );
    fastForwarded = _is.ColumnBool(
      'fastForwarded',
      this,
      hasDefault: true,
    );
  }

  late final RecheckUpdateTable updateTable;

  late final _is.ColumnInt familyId;

  late final _is.ColumnInt sourceCardId;

  late final _is.ColumnEnum<_igk9xj07.ConceptId> conceptId;

  late final _is.ColumnInt dayOffset;

  late final _is.ColumnDateTime dueAt;

  late final _is.ColumnEnum<_ibuccmzf.RecheckStatus> status;

  late final _is.ColumnInt cardId;

  /// True when a demo "jump ahead" made it due early.
  late final _is.ColumnBool fastForwarded;

  @override
  List<_is.Column> get columns => [
    id,
    familyId,
    sourceCardId,
    conceptId,
    dayOffset,
    dueAt,
    status,
    cardId,
    fastForwarded,
  ];
}

class RecheckInclude extends _is.IncludeObject {
  RecheckInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Recheck.t;
}

class RecheckIncludeList extends _is.IncludeList {
  RecheckIncludeList._({
    _is.WhereExpressionBuilder<RecheckTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Recheck.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Recheck.t;
}

class RecheckRepository {
  const RecheckRepository._();

  /// Returns a list of [Recheck]s matching the given query parameters.
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
  Future<List<Recheck>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RecheckTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RecheckTable>? orderBy,
    _is.OrderByListBuilder<RecheckTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Recheck>(
      where: where?.call(Recheck.t),
      orderBy: orderBy?.call(Recheck.t),
      orderByList: orderByList?.call(Recheck.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Recheck] matching the given query parameters.
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
  Future<Recheck?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RecheckTable>? where,
    int? offset,
    _is.OrderByBuilder<RecheckTable>? orderBy,
    _is.OrderByListBuilder<RecheckTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Recheck>(
      where: where?.call(Recheck.t),
      orderBy: orderBy?.call(Recheck.t),
      orderByList: orderByList?.call(Recheck.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Recheck] by its [id] or null if no such row exists.
  Future<Recheck?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Recheck>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Recheck]s in the list and returns the inserted rows.
  ///
  /// The returned [Recheck]s will have their `id` fields set.
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
  Future<List<Recheck>> insert(
    _is.DatabaseSession session,
    List<Recheck> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Recheck>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Recheck] and returns the inserted row.
  ///
  /// The returned [Recheck] will have its `id` field set.
  Future<Recheck> insertRow(
    _is.DatabaseSession session,
    Recheck row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Recheck>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Recheck]s in the list and returns the resulting rows.
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
  /// The returned [Recheck]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Recheck>> upsert(
    _is.DatabaseSession session,
    List<Recheck> rows, {
    required _is.ColumnSelections<RecheckTable> conflictColumns,
    _is.ColumnSelections<RecheckTable>? updateColumns,
    _is.WhereExpressionBuilder<RecheckTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Recheck>(
      rows,
      conflictColumns: conflictColumns(Recheck.t),
      updateColumns: updateColumns?.call(Recheck.t),
      updateWhere: updateWhere?.call(Recheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Recheck] and returns the resulting row.
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
  /// The returned [Recheck] will have its `id` field set.
  Future<Recheck?> upsertRow(
    _is.DatabaseSession session,
    Recheck row, {
    required _is.ColumnSelections<RecheckTable> conflictColumns,
    _is.ColumnSelections<RecheckTable>? updateColumns,
    _is.WhereExpressionBuilder<RecheckTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Recheck>(
      row,
      conflictColumns: conflictColumns(Recheck.t),
      updateColumns: updateColumns?.call(Recheck.t),
      updateWhere: updateWhere?.call(Recheck.t),
      transaction: transaction,
    );
  }

  /// Updates all [Recheck]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Recheck>> update(
    _is.DatabaseSession session,
    List<Recheck> rows, {
    _is.ColumnSelections<RecheckTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Recheck>(
      rows,
      columns: columns?.call(Recheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Recheck]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Recheck> updateRow(
    _is.DatabaseSession session,
    Recheck row, {
    _is.ColumnSelections<RecheckTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Recheck>(
      row,
      columns: columns?.call(Recheck.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Recheck] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Recheck?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<RecheckUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Recheck>(
      id,
      columnValues: columnValues(Recheck.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Recheck]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Recheck>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RecheckUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<RecheckTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RecheckTable>? orderBy,
    _is.OrderByListBuilder<RecheckTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Recheck>(
      columnValues: columnValues(Recheck.t.updateTable),
      where: where(Recheck.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Recheck.t),
      orderByList: orderByList?.call(Recheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Recheck]s in the list and returns the deleted rows.
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
  Future<List<Recheck>> delete(
    _is.DatabaseSession session,
    List<Recheck> rows, {
    _is.OrderByBuilder<RecheckTable>? orderBy,
    _is.OrderByListBuilder<RecheckTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Recheck>(
      rows,
      orderBy: orderBy?.call(Recheck.t),
      orderByList: orderByList?.call(Recheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Recheck].
  Future<Recheck> deleteRow(
    _is.DatabaseSession session,
    Recheck row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Recheck>(
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
  Future<List<Recheck>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RecheckTable> where,
    _is.OrderByBuilder<RecheckTable>? orderBy,
    _is.OrderByListBuilder<RecheckTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Recheck>(
      where: where(Recheck.t),
      orderBy: orderBy?.call(Recheck.t),
      orderByList: orderByList?.call(Recheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RecheckTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Recheck>(
      where: where?.call(Recheck.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Recheck] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RecheckTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Recheck>(
      where: where(Recheck.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
