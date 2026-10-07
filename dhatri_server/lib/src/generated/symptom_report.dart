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

abstract class SymptomReport
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SymptomReport._({
    this.id,
    required this.patientId,
    required this.checkId,
    required this.symptom,
    required this.severity,
    DateTime? reportedAt,
  }) : reportedAt = reportedAt ?? DateTime.now();

  factory SymptomReport({
    int? id,
    required int patientId,
    required int checkId,
    required String symptom,
    required int severity,
    DateTime? reportedAt,
  }) = _SymptomReportImpl;

  factory SymptomReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return SymptomReport(
      id: jsonSerialization['id'] as int?,
      patientId: jsonSerialization['patientId'] as int,
      checkId: jsonSerialization['checkId'] as int,
      symptom: jsonSerialization['symptom'] as String,
      severity: jsonSerialization['severity'] as int,
      reportedAt: jsonSerialization['reportedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['reportedAt']),
    );
  }

  static final t = SymptomReportTable();

  static const db = SymptomReportRepository._();

  @override
  int? id;

  int patientId;

  int checkId;

  String symptom;

  int severity;

  DateTime reportedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SymptomReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SymptomReport copyWith({
    int? id,
    int? patientId,
    int? checkId,
    String? symptom,
    int? severity,
    DateTime? reportedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SymptomReport',
      if (id != null) 'id': id,
      'patientId': patientId,
      'checkId': checkId,
      'symptom': symptom,
      'severity': severity,
      'reportedAt': reportedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SymptomReport',
      if (id != null) 'id': id,
      'patientId': patientId,
      'checkId': checkId,
      'symptom': symptom,
      'severity': severity,
      'reportedAt': reportedAt.toJson(),
    };
  }

  static SymptomReportInclude include() {
    return SymptomReportInclude._();
  }

  static SymptomReportIncludeList includeList({
    _is.WhereExpressionBuilder<SymptomReportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SymptomReportTable>? orderBy,
    _is.OrderByListBuilder<SymptomReportTable>? orderByList,
    SymptomReportInclude? include,
  }) {
    return SymptomReportIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SymptomReport.t),
      orderByList: orderByList?.call(SymptomReport.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SymptomReportImpl extends SymptomReport {
  _SymptomReportImpl({
    int? id,
    required int patientId,
    required int checkId,
    required String symptom,
    required int severity,
    DateTime? reportedAt,
  }) : super._(
         id: id,
         patientId: patientId,
         checkId: checkId,
         symptom: symptom,
         severity: severity,
         reportedAt: reportedAt,
       );

  /// Returns a shallow copy of this [SymptomReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SymptomReport copyWith({
    Object? id = _Undefined,
    int? patientId,
    int? checkId,
    String? symptom,
    int? severity,
    DateTime? reportedAt,
  }) {
    return SymptomReport(
      id: id is int? ? id : this.id,
      patientId: patientId ?? this.patientId,
      checkId: checkId ?? this.checkId,
      symptom: symptom ?? this.symptom,
      severity: severity ?? this.severity,
      reportedAt: reportedAt ?? this.reportedAt,
    );
  }
}

class SymptomReportUpdateTable extends _is.UpdateTable<SymptomReportTable> {
  SymptomReportUpdateTable(super.table);

  _is.ColumnValue<int, int> patientId(int value) => _is.ColumnValue(
    table.patientId,
    value,
  );

  _is.ColumnValue<int, int> checkId(int value) => _is.ColumnValue(
    table.checkId,
    value,
  );

  _is.ColumnValue<String, String> symptom(String value) => _is.ColumnValue(
    table.symptom,
    value,
  );

  _is.ColumnValue<int, int> severity(int value) => _is.ColumnValue(
    table.severity,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> reportedAt(DateTime value) =>
      _is.ColumnValue(
        table.reportedAt,
        value,
      );
}

class SymptomReportTable extends _is.Table<int?> {
  SymptomReportTable({super.tableRelation})
    : super(tableName: 'symptom_report') {
    updateTable = SymptomReportUpdateTable(this);
    patientId = _is.ColumnInt(
      'patientId',
      this,
    );
    checkId = _is.ColumnInt(
      'checkId',
      this,
    );
    symptom = _is.ColumnString(
      'symptom',
      this,
    );
    severity = _is.ColumnInt(
      'severity',
      this,
    );
    reportedAt = _is.ColumnDateTime(
      'reportedAt',
      this,
      hasDefault: true,
    );
  }

  late final SymptomReportUpdateTable updateTable;

  late final _is.ColumnInt patientId;

  late final _is.ColumnInt checkId;

  late final _is.ColumnString symptom;

  late final _is.ColumnInt severity;

  late final _is.ColumnDateTime reportedAt;

  @override
  List<_is.Column> get columns => [
    id,
    patientId,
    checkId,
    symptom,
    severity,
    reportedAt,
  ];
}

class SymptomReportInclude extends _is.IncludeObject {
  SymptomReportInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SymptomReport.t;
}

class SymptomReportIncludeList extends _is.IncludeList {
  SymptomReportIncludeList._({
    _is.WhereExpressionBuilder<SymptomReportTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SymptomReport.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SymptomReport.t;
}

class SymptomReportRepository {
  const SymptomReportRepository._();

  /// Returns a list of [SymptomReport]s matching the given query parameters.
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
  Future<List<SymptomReport>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SymptomReportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SymptomReportTable>? orderBy,
    _is.OrderByListBuilder<SymptomReportTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SymptomReport>(
      where: where?.call(SymptomReport.t),
      orderBy: orderBy?.call(SymptomReport.t),
      orderByList: orderByList?.call(SymptomReport.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SymptomReport] matching the given query parameters.
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
  Future<SymptomReport?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SymptomReportTable>? where,
    int? offset,
    _is.OrderByBuilder<SymptomReportTable>? orderBy,
    _is.OrderByListBuilder<SymptomReportTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SymptomReport>(
      where: where?.call(SymptomReport.t),
      orderBy: orderBy?.call(SymptomReport.t),
      orderByList: orderByList?.call(SymptomReport.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SymptomReport] by its [id] or null if no such row exists.
  Future<SymptomReport?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SymptomReport>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SymptomReport]s in the list and returns the inserted rows.
  ///
  /// The returned [SymptomReport]s will have their `id` fields set.
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
  Future<List<SymptomReport>> insert(
    _is.DatabaseSession session,
    List<SymptomReport> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SymptomReport>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SymptomReport] and returns the inserted row.
  ///
  /// The returned [SymptomReport] will have its `id` field set.
  Future<SymptomReport> insertRow(
    _is.DatabaseSession session,
    SymptomReport row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SymptomReport>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SymptomReport]s in the list and returns the resulting rows.
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
  /// The returned [SymptomReport]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SymptomReport>> upsert(
    _is.DatabaseSession session,
    List<SymptomReport> rows, {
    required _is.ColumnSelections<SymptomReportTable> conflictColumns,
    _is.ColumnSelections<SymptomReportTable>? updateColumns,
    _is.WhereExpressionBuilder<SymptomReportTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SymptomReport>(
      rows,
      conflictColumns: conflictColumns(SymptomReport.t),
      updateColumns: updateColumns?.call(SymptomReport.t),
      updateWhere: updateWhere?.call(SymptomReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SymptomReport] and returns the resulting row.
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
  /// The returned [SymptomReport] will have its `id` field set.
  Future<SymptomReport?> upsertRow(
    _is.DatabaseSession session,
    SymptomReport row, {
    required _is.ColumnSelections<SymptomReportTable> conflictColumns,
    _is.ColumnSelections<SymptomReportTable>? updateColumns,
    _is.WhereExpressionBuilder<SymptomReportTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SymptomReport>(
      row,
      conflictColumns: conflictColumns(SymptomReport.t),
      updateColumns: updateColumns?.call(SymptomReport.t),
      updateWhere: updateWhere?.call(SymptomReport.t),
      transaction: transaction,
    );
  }

  /// Updates all [SymptomReport]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SymptomReport>> update(
    _is.DatabaseSession session,
    List<SymptomReport> rows, {
    _is.ColumnSelections<SymptomReportTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SymptomReport>(
      rows,
      columns: columns?.call(SymptomReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SymptomReport]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SymptomReport> updateRow(
    _is.DatabaseSession session,
    SymptomReport row, {
    _is.ColumnSelections<SymptomReportTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SymptomReport>(
      row,
      columns: columns?.call(SymptomReport.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SymptomReport] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SymptomReport?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SymptomReportUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SymptomReport>(
      id,
      columnValues: columnValues(SymptomReport.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SymptomReport]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SymptomReport>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SymptomReportUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SymptomReportTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SymptomReportTable>? orderBy,
    _is.OrderByListBuilder<SymptomReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SymptomReport>(
      columnValues: columnValues(SymptomReport.t.updateTable),
      where: where(SymptomReport.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SymptomReport.t),
      orderByList: orderByList?.call(SymptomReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SymptomReport]s in the list and returns the deleted rows.
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
  Future<List<SymptomReport>> delete(
    _is.DatabaseSession session,
    List<SymptomReport> rows, {
    _is.OrderByBuilder<SymptomReportTable>? orderBy,
    _is.OrderByListBuilder<SymptomReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SymptomReport>(
      rows,
      orderBy: orderBy?.call(SymptomReport.t),
      orderByList: orderByList?.call(SymptomReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SymptomReport].
  Future<SymptomReport> deleteRow(
    _is.DatabaseSession session,
    SymptomReport row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SymptomReport>(
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
  Future<List<SymptomReport>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SymptomReportTable> where,
    _is.OrderByBuilder<SymptomReportTable>? orderBy,
    _is.OrderByListBuilder<SymptomReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SymptomReport>(
      where: where(SymptomReport.t),
      orderBy: orderBy?.call(SymptomReport.t),
      orderByList: orderByList?.call(SymptomReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SymptomReportTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SymptomReport>(
      where: where?.call(SymptomReport.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SymptomReport] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SymptomReportTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SymptomReport>(
      where: where(SymptomReport.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
