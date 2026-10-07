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
import 'alert_kind.dart' as _iyp0oawi;
import 'alert_priority.dart' as _iyhbjbo5;

abstract class Alert implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Alert._({
    this.id,
    required this.patientId,
    required this.kind,
    required this.priority,
    this.doseEventId,
    this.symptom,
    required this.message,
    DateTime? createdAt,
    this.acknowledgedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Alert({
    int? id,
    required int patientId,
    required _iyp0oawi.AlertKind kind,
    required _iyhbjbo5.AlertPriority priority,
    int? doseEventId,
    String? symptom,
    required String message,
    DateTime? createdAt,
    DateTime? acknowledgedAt,
  }) = _AlertImpl;

  factory Alert.fromJson(Map<String, dynamic> jsonSerialization) {
    return Alert(
      id: jsonSerialization['id'] as int?,
      patientId: jsonSerialization['patientId'] as int,
      kind: _iyp0oawi.AlertKind.fromJson((jsonSerialization['kind'] as String)),
      priority: _iyhbjbo5.AlertPriority.fromJson(
        (jsonSerialization['priority'] as String),
      ),
      doseEventId: jsonSerialization['doseEventId'] as int?,
      symptom: jsonSerialization['symptom'] as String?,
      message: jsonSerialization['message'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      acknowledgedAt: jsonSerialization['acknowledgedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['acknowledgedAt'],
            ),
    );
  }

  static final t = AlertTable();

  static const db = AlertRepository._();

  @override
  int? id;

  int patientId;

  _iyp0oawi.AlertKind kind;

  _iyhbjbo5.AlertPriority priority;

  int? doseEventId;

  String? symptom;

  String message;

  DateTime createdAt;

  DateTime? acknowledgedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Alert]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Alert copyWith({
    int? id,
    int? patientId,
    _iyp0oawi.AlertKind? kind,
    _iyhbjbo5.AlertPriority? priority,
    int? doseEventId,
    String? symptom,
    String? message,
    DateTime? createdAt,
    DateTime? acknowledgedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Alert',
      if (id != null) 'id': id,
      'patientId': patientId,
      'kind': kind.toJson(),
      'priority': priority.toJson(),
      if (doseEventId != null) 'doseEventId': doseEventId,
      if (symptom != null) 'symptom': symptom,
      'message': message,
      'createdAt': createdAt.toJson(),
      if (acknowledgedAt != null) 'acknowledgedAt': acknowledgedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Alert',
      if (id != null) 'id': id,
      'patientId': patientId,
      'kind': kind.toJson(),
      'priority': priority.toJson(),
      if (doseEventId != null) 'doseEventId': doseEventId,
      if (symptom != null) 'symptom': symptom,
      'message': message,
      'createdAt': createdAt.toJson(),
      if (acknowledgedAt != null) 'acknowledgedAt': acknowledgedAt?.toJson(),
    };
  }

  static AlertInclude include() {
    return AlertInclude._();
  }

  static AlertIncludeList includeList({
    _is.WhereExpressionBuilder<AlertTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AlertTable>? orderBy,
    _is.OrderByListBuilder<AlertTable>? orderByList,
    AlertInclude? include,
  }) {
    return AlertIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Alert.t),
      orderByList: orderByList?.call(Alert.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AlertImpl extends Alert {
  _AlertImpl({
    int? id,
    required int patientId,
    required _iyp0oawi.AlertKind kind,
    required _iyhbjbo5.AlertPriority priority,
    int? doseEventId,
    String? symptom,
    required String message,
    DateTime? createdAt,
    DateTime? acknowledgedAt,
  }) : super._(
         id: id,
         patientId: patientId,
         kind: kind,
         priority: priority,
         doseEventId: doseEventId,
         symptom: symptom,
         message: message,
         createdAt: createdAt,
         acknowledgedAt: acknowledgedAt,
       );

  /// Returns a shallow copy of this [Alert]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Alert copyWith({
    Object? id = _Undefined,
    int? patientId,
    _iyp0oawi.AlertKind? kind,
    _iyhbjbo5.AlertPriority? priority,
    Object? doseEventId = _Undefined,
    Object? symptom = _Undefined,
    String? message,
    DateTime? createdAt,
    Object? acknowledgedAt = _Undefined,
  }) {
    return Alert(
      id: id is int? ? id : this.id,
      patientId: patientId ?? this.patientId,
      kind: kind ?? this.kind,
      priority: priority ?? this.priority,
      doseEventId: doseEventId is int? ? doseEventId : this.doseEventId,
      symptom: symptom is String? ? symptom : this.symptom,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      acknowledgedAt: acknowledgedAt is DateTime?
          ? acknowledgedAt
          : this.acknowledgedAt,
    );
  }
}

class AlertUpdateTable extends _is.UpdateTable<AlertTable> {
  AlertUpdateTable(super.table);

  _is.ColumnValue<int, int> patientId(int value) => _is.ColumnValue(
    table.patientId,
    value,
  );

  _is.ColumnValue<_iyp0oawi.AlertKind, _iyp0oawi.AlertKind> kind(
    _iyp0oawi.AlertKind value,
  ) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<_iyhbjbo5.AlertPriority, _iyhbjbo5.AlertPriority> priority(
    _iyhbjbo5.AlertPriority value,
  ) => _is.ColumnValue(
    table.priority,
    value,
  );

  _is.ColumnValue<int, int> doseEventId(int? value) => _is.ColumnValue(
    table.doseEventId,
    value,
  );

  _is.ColumnValue<String, String> symptom(String? value) => _is.ColumnValue(
    table.symptom,
    value,
  );

  _is.ColumnValue<String, String> message(String value) => _is.ColumnValue(
    table.message,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> acknowledgedAt(DateTime? value) =>
      _is.ColumnValue(
        table.acknowledgedAt,
        value,
      );
}

class AlertTable extends _is.Table<int?> {
  AlertTable({super.tableRelation}) : super(tableName: 'alert') {
    updateTable = AlertUpdateTable(this);
    patientId = _is.ColumnInt(
      'patientId',
      this,
    );
    kind = _is.ColumnEnum(
      'kind',
      this,
      _is.EnumSerialization.byName,
    );
    priority = _is.ColumnEnum(
      'priority',
      this,
      _is.EnumSerialization.byName,
    );
    doseEventId = _is.ColumnInt(
      'doseEventId',
      this,
    );
    symptom = _is.ColumnString(
      'symptom',
      this,
    );
    message = _is.ColumnString(
      'message',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    acknowledgedAt = _is.ColumnDateTime(
      'acknowledgedAt',
      this,
    );
  }

  late final AlertUpdateTable updateTable;

  late final _is.ColumnInt patientId;

  late final _is.ColumnEnum<_iyp0oawi.AlertKind> kind;

  late final _is.ColumnEnum<_iyhbjbo5.AlertPriority> priority;

  late final _is.ColumnInt doseEventId;

  late final _is.ColumnString symptom;

  late final _is.ColumnString message;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime acknowledgedAt;

  @override
  List<_is.Column> get columns => [
    id,
    patientId,
    kind,
    priority,
    doseEventId,
    symptom,
    message,
    createdAt,
    acknowledgedAt,
  ];
}

class AlertInclude extends _is.IncludeObject {
  AlertInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Alert.t;
}

class AlertIncludeList extends _is.IncludeList {
  AlertIncludeList._({
    _is.WhereExpressionBuilder<AlertTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Alert.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Alert.t;
}

class AlertRepository {
  const AlertRepository._();

  /// Returns a list of [Alert]s matching the given query parameters.
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
  Future<List<Alert>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AlertTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AlertTable>? orderBy,
    _is.OrderByListBuilder<AlertTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Alert>(
      where: where?.call(Alert.t),
      orderBy: orderBy?.call(Alert.t),
      orderByList: orderByList?.call(Alert.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Alert] matching the given query parameters.
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
  Future<Alert?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AlertTable>? where,
    int? offset,
    _is.OrderByBuilder<AlertTable>? orderBy,
    _is.OrderByListBuilder<AlertTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Alert>(
      where: where?.call(Alert.t),
      orderBy: orderBy?.call(Alert.t),
      orderByList: orderByList?.call(Alert.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Alert] by its [id] or null if no such row exists.
  Future<Alert?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Alert>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Alert]s in the list and returns the inserted rows.
  ///
  /// The returned [Alert]s will have their `id` fields set.
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
  Future<List<Alert>> insert(
    _is.DatabaseSession session,
    List<Alert> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Alert>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Alert] and returns the inserted row.
  ///
  /// The returned [Alert] will have its `id` field set.
  Future<Alert> insertRow(
    _is.DatabaseSession session,
    Alert row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Alert>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Alert]s in the list and returns the resulting rows.
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
  /// The returned [Alert]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Alert>> upsert(
    _is.DatabaseSession session,
    List<Alert> rows, {
    required _is.ColumnSelections<AlertTable> conflictColumns,
    _is.ColumnSelections<AlertTable>? updateColumns,
    _is.WhereExpressionBuilder<AlertTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Alert>(
      rows,
      conflictColumns: conflictColumns(Alert.t),
      updateColumns: updateColumns?.call(Alert.t),
      updateWhere: updateWhere?.call(Alert.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Alert] and returns the resulting row.
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
  /// The returned [Alert] will have its `id` field set.
  Future<Alert?> upsertRow(
    _is.DatabaseSession session,
    Alert row, {
    required _is.ColumnSelections<AlertTable> conflictColumns,
    _is.ColumnSelections<AlertTable>? updateColumns,
    _is.WhereExpressionBuilder<AlertTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Alert>(
      row,
      conflictColumns: conflictColumns(Alert.t),
      updateColumns: updateColumns?.call(Alert.t),
      updateWhere: updateWhere?.call(Alert.t),
      transaction: transaction,
    );
  }

  /// Updates all [Alert]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Alert>> update(
    _is.DatabaseSession session,
    List<Alert> rows, {
    _is.ColumnSelections<AlertTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Alert>(
      rows,
      columns: columns?.call(Alert.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Alert]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Alert> updateRow(
    _is.DatabaseSession session,
    Alert row, {
    _is.ColumnSelections<AlertTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Alert>(
      row,
      columns: columns?.call(Alert.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Alert] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Alert?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AlertUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Alert>(
      id,
      columnValues: columnValues(Alert.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Alert]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Alert>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AlertUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AlertTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AlertTable>? orderBy,
    _is.OrderByListBuilder<AlertTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Alert>(
      columnValues: columnValues(Alert.t.updateTable),
      where: where(Alert.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Alert.t),
      orderByList: orderByList?.call(Alert.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Alert]s in the list and returns the deleted rows.
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
  Future<List<Alert>> delete(
    _is.DatabaseSession session,
    List<Alert> rows, {
    _is.OrderByBuilder<AlertTable>? orderBy,
    _is.OrderByListBuilder<AlertTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Alert>(
      rows,
      orderBy: orderBy?.call(Alert.t),
      orderByList: orderByList?.call(Alert.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Alert].
  Future<Alert> deleteRow(
    _is.DatabaseSession session,
    Alert row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Alert>(
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
  Future<List<Alert>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AlertTable> where,
    _is.OrderByBuilder<AlertTable>? orderBy,
    _is.OrderByListBuilder<AlertTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Alert>(
      where: where(Alert.t),
      orderBy: orderBy?.call(Alert.t),
      orderByList: orderByList?.call(Alert.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AlertTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Alert>(
      where: where?.call(Alert.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Alert] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AlertTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Alert>(
      where: where(Alert.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
