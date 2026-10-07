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

abstract class PatientMemory
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  PatientMemory._({
    this.id,
    required this.patientId,
    required this.kind,
    required this.content,
    this.sourceCheckId,
    DateTime? createdAt,
    required this.embedding,
  }) : createdAt = createdAt ?? DateTime.now();

  factory PatientMemory({
    int? id,
    required int patientId,
    required String kind,
    required String content,
    int? sourceCheckId,
    DateTime? createdAt,
    required _is.Vector embedding,
  }) = _PatientMemoryImpl;

  factory PatientMemory.fromJson(Map<String, dynamic> jsonSerialization) {
    return PatientMemory(
      id: jsonSerialization['id'] as int?,
      patientId: jsonSerialization['patientId'] as int,
      kind: jsonSerialization['kind'] as String,
      content: jsonSerialization['content'] as String,
      sourceCheckId: jsonSerialization['sourceCheckId'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      embedding: _is.VectorJsonExtension.fromJson(
        jsonSerialization['embedding'],
      ),
    );
  }

  static final t = PatientMemoryTable();

  static const db = PatientMemoryRepository._();

  @override
  int? id;

  int patientId;

  String kind;

  String content;

  int? sourceCheckId;

  DateTime createdAt;

  _is.Vector embedding;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [PatientMemory]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PatientMemory copyWith({
    int? id,
    int? patientId,
    String? kind,
    String? content,
    int? sourceCheckId,
    DateTime? createdAt,
    _is.Vector? embedding,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PatientMemory',
      if (id != null) 'id': id,
      'patientId': patientId,
      'kind': kind,
      'content': content,
      if (sourceCheckId != null) 'sourceCheckId': sourceCheckId,
      'createdAt': createdAt.toJson(),
      'embedding': embedding.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PatientMemory',
      if (id != null) 'id': id,
      'patientId': patientId,
      'kind': kind,
      'content': content,
      if (sourceCheckId != null) 'sourceCheckId': sourceCheckId,
      'createdAt': createdAt.toJson(),
      'embedding': embedding.toJson(),
    };
  }

  static PatientMemoryInclude include() {
    return PatientMemoryInclude._();
  }

  static PatientMemoryIncludeList includeList({
    _is.WhereExpressionBuilder<PatientMemoryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PatientMemoryTable>? orderBy,
    _is.OrderByListBuilder<PatientMemoryTable>? orderByList,
    PatientMemoryInclude? include,
  }) {
    return PatientMemoryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PatientMemory.t),
      orderByList: orderByList?.call(PatientMemory.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PatientMemoryImpl extends PatientMemory {
  _PatientMemoryImpl({
    int? id,
    required int patientId,
    required String kind,
    required String content,
    int? sourceCheckId,
    DateTime? createdAt,
    required _is.Vector embedding,
  }) : super._(
         id: id,
         patientId: patientId,
         kind: kind,
         content: content,
         sourceCheckId: sourceCheckId,
         createdAt: createdAt,
         embedding: embedding,
       );

  /// Returns a shallow copy of this [PatientMemory]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PatientMemory copyWith({
    Object? id = _Undefined,
    int? patientId,
    String? kind,
    String? content,
    Object? sourceCheckId = _Undefined,
    DateTime? createdAt,
    _is.Vector? embedding,
  }) {
    return PatientMemory(
      id: id is int? ? id : this.id,
      patientId: patientId ?? this.patientId,
      kind: kind ?? this.kind,
      content: content ?? this.content,
      sourceCheckId: sourceCheckId is int? ? sourceCheckId : this.sourceCheckId,
      createdAt: createdAt ?? this.createdAt,
      embedding: embedding ?? this.embedding.clone(),
    );
  }
}

class PatientMemoryUpdateTable extends _is.UpdateTable<PatientMemoryTable> {
  PatientMemoryUpdateTable(super.table);

  _is.ColumnValue<int, int> patientId(int value) => _is.ColumnValue(
    table.patientId,
    value,
  );

  _is.ColumnValue<String, String> kind(String value) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<String, String> content(String value) => _is.ColumnValue(
    table.content,
    value,
  );

  _is.ColumnValue<int, int> sourceCheckId(int? value) => _is.ColumnValue(
    table.sourceCheckId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<_is.Vector, _is.Vector> embedding(_is.Vector value) =>
      _is.ColumnValue(
        table.embedding,
        value,
      );
}

class PatientMemoryTable extends _is.Table<int?> {
  PatientMemoryTable({super.tableRelation})
    : super(tableName: 'patient_memory') {
    updateTable = PatientMemoryUpdateTable(this);
    patientId = _is.ColumnInt(
      'patientId',
      this,
    );
    kind = _is.ColumnString(
      'kind',
      this,
    );
    content = _is.ColumnString(
      'content',
      this,
    );
    sourceCheckId = _is.ColumnInt(
      'sourceCheckId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    embedding = _is.ColumnVector(
      'embedding',
      this,
      dimension: 768,
    );
  }

  late final PatientMemoryUpdateTable updateTable;

  late final _is.ColumnInt patientId;

  late final _is.ColumnString kind;

  late final _is.ColumnString content;

  late final _is.ColumnInt sourceCheckId;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnVector embedding;

  @override
  List<_is.Column> get columns => [
    id,
    patientId,
    kind,
    content,
    sourceCheckId,
    createdAt,
    embedding,
  ];
}

class PatientMemoryInclude extends _is.IncludeObject {
  PatientMemoryInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => PatientMemory.t;
}

class PatientMemoryIncludeList extends _is.IncludeList {
  PatientMemoryIncludeList._({
    _is.WhereExpressionBuilder<PatientMemoryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PatientMemory.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => PatientMemory.t;
}

class PatientMemoryRepository {
  const PatientMemoryRepository._();

  /// Returns a list of [PatientMemory]s matching the given query parameters.
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
  Future<List<PatientMemory>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PatientMemoryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PatientMemoryTable>? orderBy,
    _is.OrderByListBuilder<PatientMemoryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PatientMemory>(
      where: where?.call(PatientMemory.t),
      orderBy: orderBy?.call(PatientMemory.t),
      orderByList: orderByList?.call(PatientMemory.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PatientMemory] matching the given query parameters.
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
  Future<PatientMemory?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PatientMemoryTable>? where,
    int? offset,
    _is.OrderByBuilder<PatientMemoryTable>? orderBy,
    _is.OrderByListBuilder<PatientMemoryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PatientMemory>(
      where: where?.call(PatientMemory.t),
      orderBy: orderBy?.call(PatientMemory.t),
      orderByList: orderByList?.call(PatientMemory.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PatientMemory] by its [id] or null if no such row exists.
  Future<PatientMemory?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PatientMemory>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PatientMemory]s in the list and returns the inserted rows.
  ///
  /// The returned [PatientMemory]s will have their `id` fields set.
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
  Future<List<PatientMemory>> insert(
    _is.DatabaseSession session,
    List<PatientMemory> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PatientMemory>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PatientMemory] and returns the inserted row.
  ///
  /// The returned [PatientMemory] will have its `id` field set.
  Future<PatientMemory> insertRow(
    _is.DatabaseSession session,
    PatientMemory row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PatientMemory>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PatientMemory]s in the list and returns the resulting rows.
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
  /// The returned [PatientMemory]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PatientMemory>> upsert(
    _is.DatabaseSession session,
    List<PatientMemory> rows, {
    required _is.ColumnSelections<PatientMemoryTable> conflictColumns,
    _is.ColumnSelections<PatientMemoryTable>? updateColumns,
    _is.WhereExpressionBuilder<PatientMemoryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PatientMemory>(
      rows,
      conflictColumns: conflictColumns(PatientMemory.t),
      updateColumns: updateColumns?.call(PatientMemory.t),
      updateWhere: updateWhere?.call(PatientMemory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PatientMemory] and returns the resulting row.
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
  /// The returned [PatientMemory] will have its `id` field set.
  Future<PatientMemory?> upsertRow(
    _is.DatabaseSession session,
    PatientMemory row, {
    required _is.ColumnSelections<PatientMemoryTable> conflictColumns,
    _is.ColumnSelections<PatientMemoryTable>? updateColumns,
    _is.WhereExpressionBuilder<PatientMemoryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PatientMemory>(
      row,
      conflictColumns: conflictColumns(PatientMemory.t),
      updateColumns: updateColumns?.call(PatientMemory.t),
      updateWhere: updateWhere?.call(PatientMemory.t),
      transaction: transaction,
    );
  }

  /// Updates all [PatientMemory]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PatientMemory>> update(
    _is.DatabaseSession session,
    List<PatientMemory> rows, {
    _is.ColumnSelections<PatientMemoryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PatientMemory>(
      rows,
      columns: columns?.call(PatientMemory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PatientMemory]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PatientMemory> updateRow(
    _is.DatabaseSession session,
    PatientMemory row, {
    _is.ColumnSelections<PatientMemoryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PatientMemory>(
      row,
      columns: columns?.call(PatientMemory.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PatientMemory] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PatientMemory?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PatientMemoryUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PatientMemory>(
      id,
      columnValues: columnValues(PatientMemory.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PatientMemory]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PatientMemory>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PatientMemoryUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PatientMemoryTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PatientMemoryTable>? orderBy,
    _is.OrderByListBuilder<PatientMemoryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PatientMemory>(
      columnValues: columnValues(PatientMemory.t.updateTable),
      where: where(PatientMemory.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PatientMemory.t),
      orderByList: orderByList?.call(PatientMemory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PatientMemory]s in the list and returns the deleted rows.
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
  Future<List<PatientMemory>> delete(
    _is.DatabaseSession session,
    List<PatientMemory> rows, {
    _is.OrderByBuilder<PatientMemoryTable>? orderBy,
    _is.OrderByListBuilder<PatientMemoryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PatientMemory>(
      rows,
      orderBy: orderBy?.call(PatientMemory.t),
      orderByList: orderByList?.call(PatientMemory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PatientMemory].
  Future<PatientMemory> deleteRow(
    _is.DatabaseSession session,
    PatientMemory row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PatientMemory>(
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
  Future<List<PatientMemory>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PatientMemoryTable> where,
    _is.OrderByBuilder<PatientMemoryTable>? orderBy,
    _is.OrderByListBuilder<PatientMemoryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PatientMemory>(
      where: where(PatientMemory.t),
      orderBy: orderBy?.call(PatientMemory.t),
      orderByList: orderByList?.call(PatientMemory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PatientMemoryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PatientMemory>(
      where: where?.call(PatientMemory.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PatientMemory] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PatientMemoryTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PatientMemory>(
      where: where(PatientMemory.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
