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

abstract class FamilyMember
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  FamilyMember._({
    this.id,
    required this.familyId,
    this.authUserId,
    required this.displayName,
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  factory FamilyMember({
    int? id,
    required int familyId,
    _is.UuidValue? authUserId,
    required String displayName,
    DateTime? joinedAt,
  }) = _FamilyMemberImpl;

  factory FamilyMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return FamilyMember(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int,
      authUserId: jsonSerialization['authUserId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['authUserId'],
            ),
      displayName: jsonSerialization['displayName'] as String,
      joinedAt: jsonSerialization['joinedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
    );
  }

  static final t = FamilyMemberTable();

  static const db = FamilyMemberRepository._();

  @override
  int? id;

  int familyId;

  _is.UuidValue? authUserId;

  String displayName;

  DateTime joinedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [FamilyMember]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FamilyMember copyWith({
    int? id,
    int? familyId,
    _is.UuidValue? authUserId,
    String? displayName,
    DateTime? joinedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FamilyMember',
      if (id != null) 'id': id,
      'familyId': familyId,
      if (authUserId != null) 'authUserId': authUserId?.toJson(),
      'displayName': displayName,
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FamilyMember',
      if (id != null) 'id': id,
      'familyId': familyId,
      'displayName': displayName,
      'joinedAt': joinedAt.toJson(),
    };
  }

  static FamilyMemberInclude include() {
    return FamilyMemberInclude._();
  }

  static FamilyMemberIncludeList includeList({
    _is.WhereExpressionBuilder<FamilyMemberTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FamilyMemberTable>? orderBy,
    _is.OrderByListBuilder<FamilyMemberTable>? orderByList,
    FamilyMemberInclude? include,
  }) {
    return FamilyMemberIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FamilyMember.t),
      orderByList: orderByList?.call(FamilyMember.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FamilyMemberImpl extends FamilyMember {
  _FamilyMemberImpl({
    int? id,
    required int familyId,
    _is.UuidValue? authUserId,
    required String displayName,
    DateTime? joinedAt,
  }) : super._(
         id: id,
         familyId: familyId,
         authUserId: authUserId,
         displayName: displayName,
         joinedAt: joinedAt,
       );

  /// Returns a shallow copy of this [FamilyMember]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FamilyMember copyWith({
    Object? id = _Undefined,
    int? familyId,
    Object? authUserId = _Undefined,
    String? displayName,
    DateTime? joinedAt,
  }) {
    return FamilyMember(
      id: id is int? ? id : this.id,
      familyId: familyId ?? this.familyId,
      authUserId: authUserId is _is.UuidValue? ? authUserId : this.authUserId,
      displayName: displayName ?? this.displayName,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}

class FamilyMemberUpdateTable extends _is.UpdateTable<FamilyMemberTable> {
  FamilyMemberUpdateTable(super.table);

  _is.ColumnValue<int, int> familyId(int value) => _is.ColumnValue(
    table.familyId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> displayName(String value) => _is.ColumnValue(
    table.displayName,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> joinedAt(DateTime value) =>
      _is.ColumnValue(
        table.joinedAt,
        value,
      );
}

class FamilyMemberTable extends _is.Table<int?> {
  FamilyMemberTable({super.tableRelation}) : super(tableName: 'family_member') {
    updateTable = FamilyMemberUpdateTable(this);
    familyId = _is.ColumnInt(
      'familyId',
      this,
    );
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    displayName = _is.ColumnString(
      'displayName',
      this,
    );
    joinedAt = _is.ColumnDateTime(
      'joinedAt',
      this,
      hasDefault: true,
    );
  }

  late final FamilyMemberUpdateTable updateTable;

  late final _is.ColumnInt familyId;

  late final _is.ColumnUuid authUserId;

  late final _is.ColumnString displayName;

  late final _is.ColumnDateTime joinedAt;

  @override
  List<_is.Column> get columns => [
    id,
    familyId,
    authUserId,
    displayName,
    joinedAt,
  ];
}

class FamilyMemberInclude extends _is.IncludeObject {
  FamilyMemberInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => FamilyMember.t;
}

class FamilyMemberIncludeList extends _is.IncludeList {
  FamilyMemberIncludeList._({
    _is.WhereExpressionBuilder<FamilyMemberTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FamilyMember.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => FamilyMember.t;
}

class FamilyMemberRepository {
  const FamilyMemberRepository._();

  /// Returns a list of [FamilyMember]s matching the given query parameters.
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
  Future<List<FamilyMember>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FamilyMemberTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FamilyMemberTable>? orderBy,
    _is.OrderByListBuilder<FamilyMemberTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FamilyMember>(
      where: where?.call(FamilyMember.t),
      orderBy: orderBy?.call(FamilyMember.t),
      orderByList: orderByList?.call(FamilyMember.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FamilyMember] matching the given query parameters.
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
  Future<FamilyMember?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FamilyMemberTable>? where,
    int? offset,
    _is.OrderByBuilder<FamilyMemberTable>? orderBy,
    _is.OrderByListBuilder<FamilyMemberTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FamilyMember>(
      where: where?.call(FamilyMember.t),
      orderBy: orderBy?.call(FamilyMember.t),
      orderByList: orderByList?.call(FamilyMember.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FamilyMember] by its [id] or null if no such row exists.
  Future<FamilyMember?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FamilyMember>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FamilyMember]s in the list and returns the inserted rows.
  ///
  /// The returned [FamilyMember]s will have their `id` fields set.
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
  Future<List<FamilyMember>> insert(
    _is.DatabaseSession session,
    List<FamilyMember> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<FamilyMember>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [FamilyMember] and returns the inserted row.
  ///
  /// The returned [FamilyMember] will have its `id` field set.
  Future<FamilyMember> insertRow(
    _is.DatabaseSession session,
    FamilyMember row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<FamilyMember>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [FamilyMember]s in the list and returns the resulting rows.
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
  /// The returned [FamilyMember]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FamilyMember>> upsert(
    _is.DatabaseSession session,
    List<FamilyMember> rows, {
    required _is.ColumnSelections<FamilyMemberTable> conflictColumns,
    _is.ColumnSelections<FamilyMemberTable>? updateColumns,
    _is.WhereExpressionBuilder<FamilyMemberTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<FamilyMember>(
      rows,
      conflictColumns: conflictColumns(FamilyMember.t),
      updateColumns: updateColumns?.call(FamilyMember.t),
      updateWhere: updateWhere?.call(FamilyMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [FamilyMember] and returns the resulting row.
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
  /// The returned [FamilyMember] will have its `id` field set.
  Future<FamilyMember?> upsertRow(
    _is.DatabaseSession session,
    FamilyMember row, {
    required _is.ColumnSelections<FamilyMemberTable> conflictColumns,
    _is.ColumnSelections<FamilyMemberTable>? updateColumns,
    _is.WhereExpressionBuilder<FamilyMemberTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<FamilyMember>(
      row,
      conflictColumns: conflictColumns(FamilyMember.t),
      updateColumns: updateColumns?.call(FamilyMember.t),
      updateWhere: updateWhere?.call(FamilyMember.t),
      transaction: transaction,
    );
  }

  /// Updates all [FamilyMember]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FamilyMember>> update(
    _is.DatabaseSession session,
    List<FamilyMember> rows, {
    _is.ColumnSelections<FamilyMemberTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<FamilyMember>(
      rows,
      columns: columns?.call(FamilyMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [FamilyMember]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FamilyMember> updateRow(
    _is.DatabaseSession session,
    FamilyMember row, {
    _is.ColumnSelections<FamilyMemberTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<FamilyMember>(
      row,
      columns: columns?.call(FamilyMember.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FamilyMember] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FamilyMember?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<FamilyMemberUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<FamilyMember>(
      id,
      columnValues: columnValues(FamilyMember.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FamilyMember]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FamilyMember>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FamilyMemberUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<FamilyMemberTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FamilyMemberTable>? orderBy,
    _is.OrderByListBuilder<FamilyMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<FamilyMember>(
      columnValues: columnValues(FamilyMember.t.updateTable),
      where: where(FamilyMember.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FamilyMember.t),
      orderByList: orderByList?.call(FamilyMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [FamilyMember]s in the list and returns the deleted rows.
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
  Future<List<FamilyMember>> delete(
    _is.DatabaseSession session,
    List<FamilyMember> rows, {
    _is.OrderByBuilder<FamilyMemberTable>? orderBy,
    _is.OrderByListBuilder<FamilyMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<FamilyMember>(
      rows,
      orderBy: orderBy?.call(FamilyMember.t),
      orderByList: orderByList?.call(FamilyMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [FamilyMember].
  Future<FamilyMember> deleteRow(
    _is.DatabaseSession session,
    FamilyMember row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FamilyMember>(
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
  Future<List<FamilyMember>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FamilyMemberTable> where,
    _is.OrderByBuilder<FamilyMemberTable>? orderBy,
    _is.OrderByListBuilder<FamilyMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<FamilyMember>(
      where: where(FamilyMember.t),
      orderBy: orderBy?.call(FamilyMember.t),
      orderByList: orderByList?.call(FamilyMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FamilyMemberTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<FamilyMember>(
      where: where?.call(FamilyMember.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FamilyMember] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FamilyMemberTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FamilyMember>(
      where: where(FamilyMember.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
