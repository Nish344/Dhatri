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
import 'dose_status.dart' as _ihnxdm4b;

abstract class DoseEvent
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DoseEvent._({
    this.id,
    required this.patientId,
    required this.medicationId,
    required this.scheduledAt,
    required this.status,
    this.remindedAt,
    this.takenAt,
  });

  factory DoseEvent({
    int? id,
    required int patientId,
    required int medicationId,
    required DateTime scheduledAt,
    required _ihnxdm4b.DoseStatus status,
    DateTime? remindedAt,
    DateTime? takenAt,
  }) = _DoseEventImpl;

  factory DoseEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoseEvent(
      id: jsonSerialization['id'] as int?,
      patientId: jsonSerialization['patientId'] as int,
      medicationId: jsonSerialization['medicationId'] as int,
      scheduledAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['scheduledAt'],
      ),
      status: _ihnxdm4b.DoseStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      remindedAt: jsonSerialization['remindedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['remindedAt']),
      takenAt: jsonSerialization['takenAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['takenAt']),
    );
  }

  static final t = DoseEventTable();

  static const db = DoseEventRepository._();

  @override
  int? id;

  int patientId;

  int medicationId;

  DateTime scheduledAt;

  _ihnxdm4b.DoseStatus status;

  DateTime? remindedAt;

  DateTime? takenAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DoseEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DoseEvent copyWith({
    int? id,
    int? patientId,
    int? medicationId,
    DateTime? scheduledAt,
    _ihnxdm4b.DoseStatus? status,
    DateTime? remindedAt,
    DateTime? takenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoseEvent',
      if (id != null) 'id': id,
      'patientId': patientId,
      'medicationId': medicationId,
      'scheduledAt': scheduledAt.toJson(),
      'status': status.toJson(),
      if (remindedAt != null) 'remindedAt': remindedAt?.toJson(),
      if (takenAt != null) 'takenAt': takenAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DoseEvent',
      if (id != null) 'id': id,
      'patientId': patientId,
      'medicationId': medicationId,
      'scheduledAt': scheduledAt.toJson(),
      'status': status.toJson(),
      if (remindedAt != null) 'remindedAt': remindedAt?.toJson(),
      if (takenAt != null) 'takenAt': takenAt?.toJson(),
    };
  }

  static DoseEventInclude include() {
    return DoseEventInclude._();
  }

  static DoseEventIncludeList includeList({
    _is.WhereExpressionBuilder<DoseEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoseEventTable>? orderBy,
    _is.OrderByListBuilder<DoseEventTable>? orderByList,
    DoseEventInclude? include,
  }) {
    return DoseEventIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoseEvent.t),
      orderByList: orderByList?.call(DoseEvent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoseEventImpl extends DoseEvent {
  _DoseEventImpl({
    int? id,
    required int patientId,
    required int medicationId,
    required DateTime scheduledAt,
    required _ihnxdm4b.DoseStatus status,
    DateTime? remindedAt,
    DateTime? takenAt,
  }) : super._(
         id: id,
         patientId: patientId,
         medicationId: medicationId,
         scheduledAt: scheduledAt,
         status: status,
         remindedAt: remindedAt,
         takenAt: takenAt,
       );

  /// Returns a shallow copy of this [DoseEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DoseEvent copyWith({
    Object? id = _Undefined,
    int? patientId,
    int? medicationId,
    DateTime? scheduledAt,
    _ihnxdm4b.DoseStatus? status,
    Object? remindedAt = _Undefined,
    Object? takenAt = _Undefined,
  }) {
    return DoseEvent(
      id: id is int? ? id : this.id,
      patientId: patientId ?? this.patientId,
      medicationId: medicationId ?? this.medicationId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      remindedAt: remindedAt is DateTime? ? remindedAt : this.remindedAt,
      takenAt: takenAt is DateTime? ? takenAt : this.takenAt,
    );
  }
}

class DoseEventUpdateTable extends _is.UpdateTable<DoseEventTable> {
  DoseEventUpdateTable(super.table);

  _is.ColumnValue<int, int> patientId(int value) => _is.ColumnValue(
    table.patientId,
    value,
  );

  _is.ColumnValue<int, int> medicationId(int value) => _is.ColumnValue(
    table.medicationId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> scheduledAt(DateTime value) =>
      _is.ColumnValue(
        table.scheduledAt,
        value,
      );

  _is.ColumnValue<_ihnxdm4b.DoseStatus, _ihnxdm4b.DoseStatus> status(
    _ihnxdm4b.DoseStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> remindedAt(DateTime? value) =>
      _is.ColumnValue(
        table.remindedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> takenAt(DateTime? value) =>
      _is.ColumnValue(
        table.takenAt,
        value,
      );
}

class DoseEventTable extends _is.Table<int?> {
  DoseEventTable({super.tableRelation}) : super(tableName: 'dose_event') {
    updateTable = DoseEventUpdateTable(this);
    patientId = _is.ColumnInt(
      'patientId',
      this,
    );
    medicationId = _is.ColumnInt(
      'medicationId',
      this,
    );
    scheduledAt = _is.ColumnDateTime(
      'scheduledAt',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    remindedAt = _is.ColumnDateTime(
      'remindedAt',
      this,
    );
    takenAt = _is.ColumnDateTime(
      'takenAt',
      this,
    );
  }

  late final DoseEventUpdateTable updateTable;

  late final _is.ColumnInt patientId;

  late final _is.ColumnInt medicationId;

  late final _is.ColumnDateTime scheduledAt;

  late final _is.ColumnEnum<_ihnxdm4b.DoseStatus> status;

  late final _is.ColumnDateTime remindedAt;

  late final _is.ColumnDateTime takenAt;

  @override
  List<_is.Column> get columns => [
    id,
    patientId,
    medicationId,
    scheduledAt,
    status,
    remindedAt,
    takenAt,
  ];
}

class DoseEventInclude extends _is.IncludeObject {
  DoseEventInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DoseEvent.t;
}

class DoseEventIncludeList extends _is.IncludeList {
  DoseEventIncludeList._({
    _is.WhereExpressionBuilder<DoseEventTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DoseEvent.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DoseEvent.t;
}

class DoseEventRepository {
  const DoseEventRepository._();

  /// Returns a list of [DoseEvent]s matching the given query parameters.
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
  Future<List<DoseEvent>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoseEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoseEventTable>? orderBy,
    _is.OrderByListBuilder<DoseEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DoseEvent>(
      where: where?.call(DoseEvent.t),
      orderBy: orderBy?.call(DoseEvent.t),
      orderByList: orderByList?.call(DoseEvent.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DoseEvent] matching the given query parameters.
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
  Future<DoseEvent?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoseEventTable>? where,
    int? offset,
    _is.OrderByBuilder<DoseEventTable>? orderBy,
    _is.OrderByListBuilder<DoseEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DoseEvent>(
      where: where?.call(DoseEvent.t),
      orderBy: orderBy?.call(DoseEvent.t),
      orderByList: orderByList?.call(DoseEvent.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DoseEvent] by its [id] or null if no such row exists.
  Future<DoseEvent?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DoseEvent>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DoseEvent]s in the list and returns the inserted rows.
  ///
  /// The returned [DoseEvent]s will have their `id` fields set.
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
  Future<List<DoseEvent>> insert(
    _is.DatabaseSession session,
    List<DoseEvent> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DoseEvent>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DoseEvent] and returns the inserted row.
  ///
  /// The returned [DoseEvent] will have its `id` field set.
  Future<DoseEvent> insertRow(
    _is.DatabaseSession session,
    DoseEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DoseEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DoseEvent]s in the list and returns the resulting rows.
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
  /// The returned [DoseEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoseEvent>> upsert(
    _is.DatabaseSession session,
    List<DoseEvent> rows, {
    required _is.ColumnSelections<DoseEventTable> conflictColumns,
    _is.ColumnSelections<DoseEventTable>? updateColumns,
    _is.WhereExpressionBuilder<DoseEventTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DoseEvent>(
      rows,
      conflictColumns: conflictColumns(DoseEvent.t),
      updateColumns: updateColumns?.call(DoseEvent.t),
      updateWhere: updateWhere?.call(DoseEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DoseEvent] and returns the resulting row.
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
  /// The returned [DoseEvent] will have its `id` field set.
  Future<DoseEvent?> upsertRow(
    _is.DatabaseSession session,
    DoseEvent row, {
    required _is.ColumnSelections<DoseEventTable> conflictColumns,
    _is.ColumnSelections<DoseEventTable>? updateColumns,
    _is.WhereExpressionBuilder<DoseEventTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DoseEvent>(
      row,
      conflictColumns: conflictColumns(DoseEvent.t),
      updateColumns: updateColumns?.call(DoseEvent.t),
      updateWhere: updateWhere?.call(DoseEvent.t),
      transaction: transaction,
    );
  }

  /// Updates all [DoseEvent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoseEvent>> update(
    _is.DatabaseSession session,
    List<DoseEvent> rows, {
    _is.ColumnSelections<DoseEventTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DoseEvent>(
      rows,
      columns: columns?.call(DoseEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DoseEvent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DoseEvent> updateRow(
    _is.DatabaseSession session,
    DoseEvent row, {
    _is.ColumnSelections<DoseEventTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DoseEvent>(
      row,
      columns: columns?.call(DoseEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DoseEvent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DoseEvent?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DoseEventUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DoseEvent>(
      id,
      columnValues: columnValues(DoseEvent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DoseEvent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoseEvent>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DoseEventUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DoseEventTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoseEventTable>? orderBy,
    _is.OrderByListBuilder<DoseEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DoseEvent>(
      columnValues: columnValues(DoseEvent.t.updateTable),
      where: where(DoseEvent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoseEvent.t),
      orderByList: orderByList?.call(DoseEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DoseEvent]s in the list and returns the deleted rows.
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
  Future<List<DoseEvent>> delete(
    _is.DatabaseSession session,
    List<DoseEvent> rows, {
    _is.OrderByBuilder<DoseEventTable>? orderBy,
    _is.OrderByListBuilder<DoseEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DoseEvent>(
      rows,
      orderBy: orderBy?.call(DoseEvent.t),
      orderByList: orderByList?.call(DoseEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DoseEvent].
  Future<DoseEvent> deleteRow(
    _is.DatabaseSession session,
    DoseEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DoseEvent>(
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
  Future<List<DoseEvent>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DoseEventTable> where,
    _is.OrderByBuilder<DoseEventTable>? orderBy,
    _is.OrderByListBuilder<DoseEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DoseEvent>(
      where: where(DoseEvent.t),
      orderBy: orderBy?.call(DoseEvent.t),
      orderByList: orderByList?.call(DoseEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoseEventTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DoseEvent>(
      where: where?.call(DoseEvent.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DoseEvent] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DoseEventTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DoseEvent>(
      where: where(DoseEvent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
