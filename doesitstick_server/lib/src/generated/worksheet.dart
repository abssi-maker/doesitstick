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
import 'worksheet_status.dart' as _i3lw21mu;

/// A photographed worksheet and its trip through the background reader.
abstract class Worksheet
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Worksheet._({
    this.id,
    required this.familyId,
    required this.uploadedByName,
    this.photoPath,
    required this.status,
    this.conceptId,
    this.detectedProblems,
    this.note,
    this.cardId,
    this.photoDeletedAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Worksheet({
    int? id,
    required int familyId,
    required String uploadedByName,
    String? photoPath,
    required _i3lw21mu.WorksheetStatus status,
    _igk9xj07.ConceptId? conceptId,
    List<String>? detectedProblems,
    String? note,
    int? cardId,
    DateTime? photoDeletedAt,
    DateTime? createdAt,
  }) = _WorksheetImpl;

  factory Worksheet.fromJson(Map<String, dynamic> jsonSerialization) {
    return Worksheet(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int,
      uploadedByName: jsonSerialization['uploadedByName'] as String,
      photoPath: jsonSerialization['photoPath'] as String?,
      status: _i3lw21mu.WorksheetStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      conceptId: jsonSerialization['conceptId'] == null
          ? null
          : _igk9xj07.ConceptId.fromJson(
              (jsonSerialization['conceptId'] as String),
            ),
      detectedProblems: jsonSerialization['detectedProblems'] == null
          ? null
          : _i0djspd0.Protocol().deserialize<List<String>>(
              jsonSerialization['detectedProblems'],
            ),
      note: jsonSerialization['note'] as String?,
      cardId: jsonSerialization['cardId'] as int?,
      photoDeletedAt: jsonSerialization['photoDeletedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['photoDeletedAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = WorksheetTable();

  static const db = WorksheetRepository._();

  @override
  int? id;

  int familyId;

  String uploadedByName;

  /// Private storage path. Cleared when the photo is deleted.
  String? photoPath;

  _i3lw21mu.WorksheetStatus status;

  _igk9xj07.ConceptId? conceptId;

  /// Problems the reader saw, e.g. "46 x 7". Shown so the parent can confirm.
  List<String>? detectedProblems;

  String? note;

  int? cardId;

  DateTime? photoDeletedAt;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Worksheet]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Worksheet copyWith({
    int? id,
    int? familyId,
    String? uploadedByName,
    String? photoPath,
    _i3lw21mu.WorksheetStatus? status,
    _igk9xj07.ConceptId? conceptId,
    List<String>? detectedProblems,
    String? note,
    int? cardId,
    DateTime? photoDeletedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Worksheet',
      if (id != null) 'id': id,
      'familyId': familyId,
      'uploadedByName': uploadedByName,
      if (photoPath != null) 'photoPath': photoPath,
      'status': status.toJson(),
      if (conceptId != null) 'conceptId': conceptId?.toJson(),
      if (detectedProblems != null)
        'detectedProblems': detectedProblems?.toJson(),
      if (note != null) 'note': note,
      if (cardId != null) 'cardId': cardId,
      if (photoDeletedAt != null) 'photoDeletedAt': photoDeletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Worksheet',
      if (id != null) 'id': id,
      'familyId': familyId,
      'uploadedByName': uploadedByName,
      'status': status.toJson(),
      if (conceptId != null) 'conceptId': conceptId?.toJson(),
      if (detectedProblems != null)
        'detectedProblems': detectedProblems?.toJson(),
      if (note != null) 'note': note,
      if (cardId != null) 'cardId': cardId,
      if (photoDeletedAt != null) 'photoDeletedAt': photoDeletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static WorksheetInclude include() {
    return WorksheetInclude._();
  }

  static WorksheetIncludeList includeList({
    _is.WhereExpressionBuilder<WorksheetTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WorksheetTable>? orderBy,
    _is.OrderByListBuilder<WorksheetTable>? orderByList,
    WorksheetInclude? include,
  }) {
    return WorksheetIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Worksheet.t),
      orderByList: orderByList?.call(Worksheet.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorksheetImpl extends Worksheet {
  _WorksheetImpl({
    int? id,
    required int familyId,
    required String uploadedByName,
    String? photoPath,
    required _i3lw21mu.WorksheetStatus status,
    _igk9xj07.ConceptId? conceptId,
    List<String>? detectedProblems,
    String? note,
    int? cardId,
    DateTime? photoDeletedAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         familyId: familyId,
         uploadedByName: uploadedByName,
         photoPath: photoPath,
         status: status,
         conceptId: conceptId,
         detectedProblems: detectedProblems,
         note: note,
         cardId: cardId,
         photoDeletedAt: photoDeletedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Worksheet]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Worksheet copyWith({
    Object? id = _Undefined,
    int? familyId,
    String? uploadedByName,
    Object? photoPath = _Undefined,
    _i3lw21mu.WorksheetStatus? status,
    Object? conceptId = _Undefined,
    Object? detectedProblems = _Undefined,
    Object? note = _Undefined,
    Object? cardId = _Undefined,
    Object? photoDeletedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return Worksheet(
      id: id is int? ? id : this.id,
      familyId: familyId ?? this.familyId,
      uploadedByName: uploadedByName ?? this.uploadedByName,
      photoPath: photoPath is String? ? photoPath : this.photoPath,
      status: status ?? this.status,
      conceptId: conceptId is _igk9xj07.ConceptId? ? conceptId : this.conceptId,
      detectedProblems: detectedProblems is List<String>?
          ? detectedProblems
          : this.detectedProblems?.map((e0) => e0).toList(),
      note: note is String? ? note : this.note,
      cardId: cardId is int? ? cardId : this.cardId,
      photoDeletedAt: photoDeletedAt is DateTime?
          ? photoDeletedAt
          : this.photoDeletedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class WorksheetUpdateTable extends _is.UpdateTable<WorksheetTable> {
  WorksheetUpdateTable(super.table);

  _is.ColumnValue<int, int> familyId(int value) => _is.ColumnValue(
    table.familyId,
    value,
  );

  _is.ColumnValue<String, String> uploadedByName(String value) =>
      _is.ColumnValue(
        table.uploadedByName,
        value,
      );

  _is.ColumnValue<String, String> photoPath(String? value) => _is.ColumnValue(
    table.photoPath,
    value,
  );

  _is.ColumnValue<_i3lw21mu.WorksheetStatus, _i3lw21mu.WorksheetStatus> status(
    _i3lw21mu.WorksheetStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<_igk9xj07.ConceptId, _igk9xj07.ConceptId> conceptId(
    _igk9xj07.ConceptId? value,
  ) => _is.ColumnValue(
    table.conceptId,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> detectedProblems(
    List<String>? value,
  ) => _is.ColumnValue(
    table.detectedProblems,
    value,
  );

  _is.ColumnValue<String, String> note(String? value) => _is.ColumnValue(
    table.note,
    value,
  );

  _is.ColumnValue<int, int> cardId(int? value) => _is.ColumnValue(
    table.cardId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> photoDeletedAt(DateTime? value) =>
      _is.ColumnValue(
        table.photoDeletedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class WorksheetTable extends _is.Table<int?> {
  WorksheetTable({super.tableRelation}) : super(tableName: 'worksheet') {
    updateTable = WorksheetUpdateTable(this);
    familyId = _is.ColumnInt(
      'familyId',
      this,
    );
    uploadedByName = _is.ColumnString(
      'uploadedByName',
      this,
    );
    photoPath = _is.ColumnString(
      'photoPath',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    conceptId = _is.ColumnEnum(
      'conceptId',
      this,
      _is.EnumSerialization.byName,
    );
    detectedProblems = _is.ColumnSerializable<List<String>>(
      'detectedProblems',
      this,
    );
    note = _is.ColumnString(
      'note',
      this,
    );
    cardId = _is.ColumnInt(
      'cardId',
      this,
    );
    photoDeletedAt = _is.ColumnDateTime(
      'photoDeletedAt',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final WorksheetUpdateTable updateTable;

  late final _is.ColumnInt familyId;

  late final _is.ColumnString uploadedByName;

  /// Private storage path. Cleared when the photo is deleted.
  late final _is.ColumnString photoPath;

  late final _is.ColumnEnum<_i3lw21mu.WorksheetStatus> status;

  late final _is.ColumnEnum<_igk9xj07.ConceptId> conceptId;

  /// Problems the reader saw, e.g. "46 x 7". Shown so the parent can confirm.
  late final _is.ColumnSerializable<List<String>> detectedProblems;

  late final _is.ColumnString note;

  late final _is.ColumnInt cardId;

  late final _is.ColumnDateTime photoDeletedAt;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    familyId,
    uploadedByName,
    photoPath,
    status,
    conceptId,
    detectedProblems,
    note,
    cardId,
    photoDeletedAt,
    createdAt,
  ];
}

class WorksheetInclude extends _is.IncludeObject {
  WorksheetInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Worksheet.t;
}

class WorksheetIncludeList extends _is.IncludeList {
  WorksheetIncludeList._({
    _is.WhereExpressionBuilder<WorksheetTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Worksheet.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Worksheet.t;
}

class WorksheetRepository {
  const WorksheetRepository._();

  /// Returns a list of [Worksheet]s matching the given query parameters.
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
  Future<List<Worksheet>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WorksheetTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WorksheetTable>? orderBy,
    _is.OrderByListBuilder<WorksheetTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Worksheet>(
      where: where?.call(Worksheet.t),
      orderBy: orderBy?.call(Worksheet.t),
      orderByList: orderByList?.call(Worksheet.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Worksheet] matching the given query parameters.
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
  Future<Worksheet?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WorksheetTable>? where,
    int? offset,
    _is.OrderByBuilder<WorksheetTable>? orderBy,
    _is.OrderByListBuilder<WorksheetTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Worksheet>(
      where: where?.call(Worksheet.t),
      orderBy: orderBy?.call(Worksheet.t),
      orderByList: orderByList?.call(Worksheet.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Worksheet] by its [id] or null if no such row exists.
  Future<Worksheet?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Worksheet>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Worksheet]s in the list and returns the inserted rows.
  ///
  /// The returned [Worksheet]s will have their `id` fields set.
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
  Future<List<Worksheet>> insert(
    _is.DatabaseSession session,
    List<Worksheet> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Worksheet>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Worksheet] and returns the inserted row.
  ///
  /// The returned [Worksheet] will have its `id` field set.
  Future<Worksheet> insertRow(
    _is.DatabaseSession session,
    Worksheet row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Worksheet>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Worksheet]s in the list and returns the resulting rows.
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
  /// The returned [Worksheet]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Worksheet>> upsert(
    _is.DatabaseSession session,
    List<Worksheet> rows, {
    required _is.ColumnSelections<WorksheetTable> conflictColumns,
    _is.ColumnSelections<WorksheetTable>? updateColumns,
    _is.WhereExpressionBuilder<WorksheetTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Worksheet>(
      rows,
      conflictColumns: conflictColumns(Worksheet.t),
      updateColumns: updateColumns?.call(Worksheet.t),
      updateWhere: updateWhere?.call(Worksheet.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Worksheet] and returns the resulting row.
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
  /// The returned [Worksheet] will have its `id` field set.
  Future<Worksheet?> upsertRow(
    _is.DatabaseSession session,
    Worksheet row, {
    required _is.ColumnSelections<WorksheetTable> conflictColumns,
    _is.ColumnSelections<WorksheetTable>? updateColumns,
    _is.WhereExpressionBuilder<WorksheetTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Worksheet>(
      row,
      conflictColumns: conflictColumns(Worksheet.t),
      updateColumns: updateColumns?.call(Worksheet.t),
      updateWhere: updateWhere?.call(Worksheet.t),
      transaction: transaction,
    );
  }

  /// Updates all [Worksheet]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Worksheet>> update(
    _is.DatabaseSession session,
    List<Worksheet> rows, {
    _is.ColumnSelections<WorksheetTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Worksheet>(
      rows,
      columns: columns?.call(Worksheet.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Worksheet]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Worksheet> updateRow(
    _is.DatabaseSession session,
    Worksheet row, {
    _is.ColumnSelections<WorksheetTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Worksheet>(
      row,
      columns: columns?.call(Worksheet.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Worksheet] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Worksheet?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<WorksheetUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Worksheet>(
      id,
      columnValues: columnValues(Worksheet.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Worksheet]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Worksheet>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<WorksheetUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<WorksheetTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WorksheetTable>? orderBy,
    _is.OrderByListBuilder<WorksheetTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Worksheet>(
      columnValues: columnValues(Worksheet.t.updateTable),
      where: where(Worksheet.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Worksheet.t),
      orderByList: orderByList?.call(Worksheet.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Worksheet]s in the list and returns the deleted rows.
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
  Future<List<Worksheet>> delete(
    _is.DatabaseSession session,
    List<Worksheet> rows, {
    _is.OrderByBuilder<WorksheetTable>? orderBy,
    _is.OrderByListBuilder<WorksheetTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Worksheet>(
      rows,
      orderBy: orderBy?.call(Worksheet.t),
      orderByList: orderByList?.call(Worksheet.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Worksheet].
  Future<Worksheet> deleteRow(
    _is.DatabaseSession session,
    Worksheet row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Worksheet>(
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
  Future<List<Worksheet>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WorksheetTable> where,
    _is.OrderByBuilder<WorksheetTable>? orderBy,
    _is.OrderByListBuilder<WorksheetTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Worksheet>(
      where: where(Worksheet.t),
      orderBy: orderBy?.call(Worksheet.t),
      orderByList: orderByList?.call(Worksheet.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WorksheetTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Worksheet>(
      where: where?.call(Worksheet.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Worksheet] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WorksheetTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Worksheet>(
      where: where(Worksheet.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
