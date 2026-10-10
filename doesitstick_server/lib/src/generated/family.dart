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

/// A household: up to two parents sharing one child's progress.
abstract class Family implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Family._({
    this.id,
    required this.childName,
    required this.inviteCode,
    this.shareToken,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Family({
    int? id,
    required String childName,
    required String inviteCode,
    String? shareToken,
    DateTime? createdAt,
  }) = _FamilyImpl;

  factory Family.fromJson(Map<String, dynamic> jsonSerialization) {
    return Family(
      id: jsonSerialization['id'] as int?,
      childName: jsonSerialization['childName'] as String,
      inviteCode: jsonSerialization['inviteCode'] as String,
      shareToken: jsonSerialization['shareToken'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = FamilyTable();

  static const db = FamilyRepository._();

  @override
  int? id;

  String childName;

  String inviteCode;

  /// Set only when a parent shares the weekly page; revocable.
  String? shareToken;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Family]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Family copyWith({
    int? id,
    String? childName,
    String? inviteCode,
    String? shareToken,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Family',
      if (id != null) 'id': id,
      'childName': childName,
      'inviteCode': inviteCode,
      if (shareToken != null) 'shareToken': shareToken,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Family',
      if (id != null) 'id': id,
      'childName': childName,
      'inviteCode': inviteCode,
      if (shareToken != null) 'shareToken': shareToken,
      'createdAt': createdAt.toJson(),
    };
  }

  static FamilyInclude include() {
    return FamilyInclude._();
  }

  static FamilyIncludeList includeList({
    _is.WhereExpressionBuilder<FamilyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FamilyTable>? orderBy,
    _is.OrderByListBuilder<FamilyTable>? orderByList,
    FamilyInclude? include,
  }) {
    return FamilyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Family.t),
      orderByList: orderByList?.call(Family.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FamilyImpl extends Family {
  _FamilyImpl({
    int? id,
    required String childName,
    required String inviteCode,
    String? shareToken,
    DateTime? createdAt,
  }) : super._(
         id: id,
         childName: childName,
         inviteCode: inviteCode,
         shareToken: shareToken,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Family]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Family copyWith({
    Object? id = _Undefined,
    String? childName,
    String? inviteCode,
    Object? shareToken = _Undefined,
    DateTime? createdAt,
  }) {
    return Family(
      id: id is int? ? id : this.id,
      childName: childName ?? this.childName,
      inviteCode: inviteCode ?? this.inviteCode,
      shareToken: shareToken is String? ? shareToken : this.shareToken,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class FamilyUpdateTable extends _is.UpdateTable<FamilyTable> {
  FamilyUpdateTable(super.table);

  _is.ColumnValue<String, String> childName(String value) => _is.ColumnValue(
    table.childName,
    value,
  );

  _is.ColumnValue<String, String> inviteCode(String value) => _is.ColumnValue(
    table.inviteCode,
    value,
  );

  _is.ColumnValue<String, String> shareToken(String? value) => _is.ColumnValue(
    table.shareToken,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class FamilyTable extends _is.Table<int?> {
  FamilyTable({super.tableRelation}) : super(tableName: 'family') {
    updateTable = FamilyUpdateTable(this);
    childName = _is.ColumnString(
      'childName',
      this,
    );
    inviteCode = _is.ColumnString(
      'inviteCode',
      this,
    );
    shareToken = _is.ColumnString(
      'shareToken',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final FamilyUpdateTable updateTable;

  late final _is.ColumnString childName;

  late final _is.ColumnString inviteCode;

  /// Set only when a parent shares the weekly page; revocable.
  late final _is.ColumnString shareToken;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    childName,
    inviteCode,
    shareToken,
    createdAt,
  ];
}

class FamilyInclude extends _is.IncludeObject {
  FamilyInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Family.t;
}

class FamilyIncludeList extends _is.IncludeList {
  FamilyIncludeList._({
    _is.WhereExpressionBuilder<FamilyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Family.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Family.t;
}

class FamilyRepository {
  const FamilyRepository._();

  /// Returns a list of [Family]s matching the given query parameters.
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
  Future<List<Family>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FamilyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FamilyTable>? orderBy,
    _is.OrderByListBuilder<FamilyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Family>(
      where: where?.call(Family.t),
      orderBy: orderBy?.call(Family.t),
      orderByList: orderByList?.call(Family.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Family] matching the given query parameters.
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
  Future<Family?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FamilyTable>? where,
    int? offset,
    _is.OrderByBuilder<FamilyTable>? orderBy,
    _is.OrderByListBuilder<FamilyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Family>(
      where: where?.call(Family.t),
      orderBy: orderBy?.call(Family.t),
      orderByList: orderByList?.call(Family.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Family] by its [id] or null if no such row exists.
  Future<Family?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Family>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Family]s in the list and returns the inserted rows.
  ///
  /// The returned [Family]s will have their `id` fields set.
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
  Future<List<Family>> insert(
    _is.DatabaseSession session,
    List<Family> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Family>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Family] and returns the inserted row.
  ///
  /// The returned [Family] will have its `id` field set.
  Future<Family> insertRow(
    _is.DatabaseSession session,
    Family row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Family>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Family]s in the list and returns the resulting rows.
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
  /// The returned [Family]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Family>> upsert(
    _is.DatabaseSession session,
    List<Family> rows, {
    required _is.ColumnSelections<FamilyTable> conflictColumns,
    _is.ColumnSelections<FamilyTable>? updateColumns,
    _is.WhereExpressionBuilder<FamilyTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Family>(
      rows,
      conflictColumns: conflictColumns(Family.t),
      updateColumns: updateColumns?.call(Family.t),
      updateWhere: updateWhere?.call(Family.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Family] and returns the resulting row.
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
  /// The returned [Family] will have its `id` field set.
  Future<Family?> upsertRow(
    _is.DatabaseSession session,
    Family row, {
    required _is.ColumnSelections<FamilyTable> conflictColumns,
    _is.ColumnSelections<FamilyTable>? updateColumns,
    _is.WhereExpressionBuilder<FamilyTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Family>(
      row,
      conflictColumns: conflictColumns(Family.t),
      updateColumns: updateColumns?.call(Family.t),
      updateWhere: updateWhere?.call(Family.t),
      transaction: transaction,
    );
  }

  /// Updates all [Family]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Family>> update(
    _is.DatabaseSession session,
    List<Family> rows, {
    _is.ColumnSelections<FamilyTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Family>(
      rows,
      columns: columns?.call(Family.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Family]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Family> updateRow(
    _is.DatabaseSession session,
    Family row, {
    _is.ColumnSelections<FamilyTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Family>(
      row,
      columns: columns?.call(Family.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Family] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Family?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<FamilyUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Family>(
      id,
      columnValues: columnValues(Family.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Family]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Family>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FamilyUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<FamilyTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FamilyTable>? orderBy,
    _is.OrderByListBuilder<FamilyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Family>(
      columnValues: columnValues(Family.t.updateTable),
      where: where(Family.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Family.t),
      orderByList: orderByList?.call(Family.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Family]s in the list and returns the deleted rows.
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
  Future<List<Family>> delete(
    _is.DatabaseSession session,
    List<Family> rows, {
    _is.OrderByBuilder<FamilyTable>? orderBy,
    _is.OrderByListBuilder<FamilyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Family>(
      rows,
      orderBy: orderBy?.call(Family.t),
      orderByList: orderByList?.call(Family.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Family].
  Future<Family> deleteRow(
    _is.DatabaseSession session,
    Family row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Family>(
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
  Future<List<Family>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FamilyTable> where,
    _is.OrderByBuilder<FamilyTable>? orderBy,
    _is.OrderByListBuilder<FamilyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Family>(
      where: where(Family.t),
      orderBy: orderBy?.call(Family.t),
      orderByList: orderByList?.call(Family.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FamilyTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Family>(
      where: where?.call(Family.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Family] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FamilyTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Family>(
      where: where(Family.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
