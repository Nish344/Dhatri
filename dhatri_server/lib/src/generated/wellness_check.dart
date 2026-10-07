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
import 'package:dhatri_server/src/generated/protocol.dart' as _iig3g4e3;
import 'package:serverpod/serverpod.dart' as _is;
import 'check_status.dart' as _i152b260;
import 'check_trigger.dart' as _i06tdmkm;

abstract class WellnessCheck
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  WellnessCheck._({
    this.id,
    required this.patientId,
    required this.status,
    required this.trigger,
    int? turnCount,
    this.transcript,
    this.replyText,
    this.mood,
    this.summaryEn,
    this.memoryUsed,
    DateTime? createdAt,
    this.completedAt,
  }) : turnCount = turnCount ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory WellnessCheck({
    int? id,
    required int patientId,
    required _i152b260.CheckStatus status,
    required _i06tdmkm.CheckTrigger trigger,
    int? turnCount,
    String? transcript,
    String? replyText,
    String? mood,
    String? summaryEn,
    List<String>? memoryUsed,
    DateTime? createdAt,
    DateTime? completedAt,
  }) = _WellnessCheckImpl;

  factory WellnessCheck.fromJson(Map<String, dynamic> jsonSerialization) {
    return WellnessCheck(
      id: jsonSerialization['id'] as int?,
      patientId: jsonSerialization['patientId'] as int,
      status: _i152b260.CheckStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      trigger: _i06tdmkm.CheckTrigger.fromJson(
        (jsonSerialization['trigger'] as String),
      ),
      turnCount: jsonSerialization['turnCount'] as int?,
      transcript: jsonSerialization['transcript'] as String?,
      replyText: jsonSerialization['replyText'] as String?,
      mood: jsonSerialization['mood'] as String?,
      summaryEn: jsonSerialization['summaryEn'] as String?,
      memoryUsed: jsonSerialization['memoryUsed'] == null
          ? null
          : _iig3g4e3.Protocol().deserialize<List<String>>(
              jsonSerialization['memoryUsed'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
    );
  }

  static final t = WellnessCheckTable();

  static const db = WellnessCheckRepository._();

  @override
  int? id;

  int patientId;

  _i152b260.CheckStatus status;

  _i06tdmkm.CheckTrigger trigger;

  int turnCount;

  String? transcript;

  String? replyText;

  String? mood;

  String? summaryEn;

  List<String>? memoryUsed;

  DateTime createdAt;

  DateTime? completedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [WellnessCheck]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WellnessCheck copyWith({
    int? id,
    int? patientId,
    _i152b260.CheckStatus? status,
    _i06tdmkm.CheckTrigger? trigger,
    int? turnCount,
    String? transcript,
    String? replyText,
    String? mood,
    String? summaryEn,
    List<String>? memoryUsed,
    DateTime? createdAt,
    DateTime? completedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WellnessCheck',
      if (id != null) 'id': id,
      'patientId': patientId,
      'status': status.toJson(),
      'trigger': trigger.toJson(),
      'turnCount': turnCount,
      if (transcript != null) 'transcript': transcript,
      if (replyText != null) 'replyText': replyText,
      if (mood != null) 'mood': mood,
      if (summaryEn != null) 'summaryEn': summaryEn,
      if (memoryUsed != null) 'memoryUsed': memoryUsed?.toJson(),
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WellnessCheck',
      if (id != null) 'id': id,
      'patientId': patientId,
      'status': status.toJson(),
      'trigger': trigger.toJson(),
      'turnCount': turnCount,
      if (transcript != null) 'transcript': transcript,
      if (replyText != null) 'replyText': replyText,
      if (mood != null) 'mood': mood,
      if (summaryEn != null) 'summaryEn': summaryEn,
      if (memoryUsed != null) 'memoryUsed': memoryUsed?.toJson(),
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  static WellnessCheckInclude include() {
    return WellnessCheckInclude._();
  }

  static WellnessCheckIncludeList includeList({
    _is.WhereExpressionBuilder<WellnessCheckTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WellnessCheckTable>? orderBy,
    _is.OrderByListBuilder<WellnessCheckTable>? orderByList,
    WellnessCheckInclude? include,
  }) {
    return WellnessCheckIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WellnessCheck.t),
      orderByList: orderByList?.call(WellnessCheck.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WellnessCheckImpl extends WellnessCheck {
  _WellnessCheckImpl({
    int? id,
    required int patientId,
    required _i152b260.CheckStatus status,
    required _i06tdmkm.CheckTrigger trigger,
    int? turnCount,
    String? transcript,
    String? replyText,
    String? mood,
    String? summaryEn,
    List<String>? memoryUsed,
    DateTime? createdAt,
    DateTime? completedAt,
  }) : super._(
         id: id,
         patientId: patientId,
         status: status,
         trigger: trigger,
         turnCount: turnCount,
         transcript: transcript,
         replyText: replyText,
         mood: mood,
         summaryEn: summaryEn,
         memoryUsed: memoryUsed,
         createdAt: createdAt,
         completedAt: completedAt,
       );

  /// Returns a shallow copy of this [WellnessCheck]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WellnessCheck copyWith({
    Object? id = _Undefined,
    int? patientId,
    _i152b260.CheckStatus? status,
    _i06tdmkm.CheckTrigger? trigger,
    int? turnCount,
    Object? transcript = _Undefined,
    Object? replyText = _Undefined,
    Object? mood = _Undefined,
    Object? summaryEn = _Undefined,
    Object? memoryUsed = _Undefined,
    DateTime? createdAt,
    Object? completedAt = _Undefined,
  }) {
    return WellnessCheck(
      id: id is int? ? id : this.id,
      patientId: patientId ?? this.patientId,
      status: status ?? this.status,
      trigger: trigger ?? this.trigger,
      turnCount: turnCount ?? this.turnCount,
      transcript: transcript is String? ? transcript : this.transcript,
      replyText: replyText is String? ? replyText : this.replyText,
      mood: mood is String? ? mood : this.mood,
      summaryEn: summaryEn is String? ? summaryEn : this.summaryEn,
      memoryUsed: memoryUsed is List<String>?
          ? memoryUsed
          : this.memoryUsed?.map((e0) => e0).toList(),
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
    );
  }
}

class WellnessCheckUpdateTable extends _is.UpdateTable<WellnessCheckTable> {
  WellnessCheckUpdateTable(super.table);

  _is.ColumnValue<int, int> patientId(int value) => _is.ColumnValue(
    table.patientId,
    value,
  );

  _is.ColumnValue<_i152b260.CheckStatus, _i152b260.CheckStatus> status(
    _i152b260.CheckStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<_i06tdmkm.CheckTrigger, _i06tdmkm.CheckTrigger> trigger(
    _i06tdmkm.CheckTrigger value,
  ) => _is.ColumnValue(
    table.trigger,
    value,
  );

  _is.ColumnValue<int, int> turnCount(int value) => _is.ColumnValue(
    table.turnCount,
    value,
  );

  _is.ColumnValue<String, String> transcript(String? value) => _is.ColumnValue(
    table.transcript,
    value,
  );

  _is.ColumnValue<String, String> replyText(String? value) => _is.ColumnValue(
    table.replyText,
    value,
  );

  _is.ColumnValue<String, String> mood(String? value) => _is.ColumnValue(
    table.mood,
    value,
  );

  _is.ColumnValue<String, String> summaryEn(String? value) => _is.ColumnValue(
    table.summaryEn,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> memoryUsed(List<String>? value) =>
      _is.ColumnValue(
        table.memoryUsed,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> completedAt(DateTime? value) =>
      _is.ColumnValue(
        table.completedAt,
        value,
      );
}

class WellnessCheckTable extends _is.Table<int?> {
  WellnessCheckTable({super.tableRelation})
    : super(tableName: 'wellness_check') {
    updateTable = WellnessCheckUpdateTable(this);
    patientId = _is.ColumnInt(
      'patientId',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    trigger = _is.ColumnEnum(
      'trigger',
      this,
      _is.EnumSerialization.byName,
    );
    turnCount = _is.ColumnInt(
      'turnCount',
      this,
      hasDefault: true,
    );
    transcript = _is.ColumnString(
      'transcript',
      this,
    );
    replyText = _is.ColumnString(
      'replyText',
      this,
    );
    mood = _is.ColumnString(
      'mood',
      this,
    );
    summaryEn = _is.ColumnString(
      'summaryEn',
      this,
    );
    memoryUsed = _is.ColumnSerializable<List<String>>(
      'memoryUsed',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    completedAt = _is.ColumnDateTime(
      'completedAt',
      this,
    );
  }

  late final WellnessCheckUpdateTable updateTable;

  late final _is.ColumnInt patientId;

  late final _is.ColumnEnum<_i152b260.CheckStatus> status;

  late final _is.ColumnEnum<_i06tdmkm.CheckTrigger> trigger;

  late final _is.ColumnInt turnCount;

  late final _is.ColumnString transcript;

  late final _is.ColumnString replyText;

  late final _is.ColumnString mood;

  late final _is.ColumnString summaryEn;

  late final _is.ColumnSerializable<List<String>> memoryUsed;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime completedAt;

  @override
  List<_is.Column> get columns => [
    id,
    patientId,
    status,
    trigger,
    turnCount,
    transcript,
    replyText,
    mood,
    summaryEn,
    memoryUsed,
    createdAt,
    completedAt,
  ];
}

class WellnessCheckInclude extends _is.IncludeObject {
  WellnessCheckInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => WellnessCheck.t;
}

class WellnessCheckIncludeList extends _is.IncludeList {
  WellnessCheckIncludeList._({
    _is.WhereExpressionBuilder<WellnessCheckTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WellnessCheck.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => WellnessCheck.t;
}

class WellnessCheckRepository {
  const WellnessCheckRepository._();

  /// Returns a list of [WellnessCheck]s matching the given query parameters.
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
  Future<List<WellnessCheck>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WellnessCheckTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WellnessCheckTable>? orderBy,
    _is.OrderByListBuilder<WellnessCheckTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<WellnessCheck>(
      where: where?.call(WellnessCheck.t),
      orderBy: orderBy?.call(WellnessCheck.t),
      orderByList: orderByList?.call(WellnessCheck.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [WellnessCheck] matching the given query parameters.
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
  Future<WellnessCheck?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WellnessCheckTable>? where,
    int? offset,
    _is.OrderByBuilder<WellnessCheckTable>? orderBy,
    _is.OrderByListBuilder<WellnessCheckTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<WellnessCheck>(
      where: where?.call(WellnessCheck.t),
      orderBy: orderBy?.call(WellnessCheck.t),
      orderByList: orderByList?.call(WellnessCheck.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [WellnessCheck] by its [id] or null if no such row exists.
  Future<WellnessCheck?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<WellnessCheck>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [WellnessCheck]s in the list and returns the inserted rows.
  ///
  /// The returned [WellnessCheck]s will have their `id` fields set.
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
  Future<List<WellnessCheck>> insert(
    _is.DatabaseSession session,
    List<WellnessCheck> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<WellnessCheck>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [WellnessCheck] and returns the inserted row.
  ///
  /// The returned [WellnessCheck] will have its `id` field set.
  Future<WellnessCheck> insertRow(
    _is.DatabaseSession session,
    WellnessCheck row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<WellnessCheck>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [WellnessCheck]s in the list and returns the resulting rows.
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
  /// The returned [WellnessCheck]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WellnessCheck>> upsert(
    _is.DatabaseSession session,
    List<WellnessCheck> rows, {
    required _is.ColumnSelections<WellnessCheckTable> conflictColumns,
    _is.ColumnSelections<WellnessCheckTable>? updateColumns,
    _is.WhereExpressionBuilder<WellnessCheckTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<WellnessCheck>(
      rows,
      conflictColumns: conflictColumns(WellnessCheck.t),
      updateColumns: updateColumns?.call(WellnessCheck.t),
      updateWhere: updateWhere?.call(WellnessCheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [WellnessCheck] and returns the resulting row.
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
  /// The returned [WellnessCheck] will have its `id` field set.
  Future<WellnessCheck?> upsertRow(
    _is.DatabaseSession session,
    WellnessCheck row, {
    required _is.ColumnSelections<WellnessCheckTable> conflictColumns,
    _is.ColumnSelections<WellnessCheckTable>? updateColumns,
    _is.WhereExpressionBuilder<WellnessCheckTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<WellnessCheck>(
      row,
      conflictColumns: conflictColumns(WellnessCheck.t),
      updateColumns: updateColumns?.call(WellnessCheck.t),
      updateWhere: updateWhere?.call(WellnessCheck.t),
      transaction: transaction,
    );
  }

  /// Updates all [WellnessCheck]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WellnessCheck>> update(
    _is.DatabaseSession session,
    List<WellnessCheck> rows, {
    _is.ColumnSelections<WellnessCheckTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<WellnessCheck>(
      rows,
      columns: columns?.call(WellnessCheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [WellnessCheck]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WellnessCheck> updateRow(
    _is.DatabaseSession session,
    WellnessCheck row, {
    _is.ColumnSelections<WellnessCheckTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<WellnessCheck>(
      row,
      columns: columns?.call(WellnessCheck.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WellnessCheck] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<WellnessCheck?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<WellnessCheckUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<WellnessCheck>(
      id,
      columnValues: columnValues(WellnessCheck.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [WellnessCheck]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WellnessCheck>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<WellnessCheckUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<WellnessCheckTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WellnessCheckTable>? orderBy,
    _is.OrderByListBuilder<WellnessCheckTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<WellnessCheck>(
      columnValues: columnValues(WellnessCheck.t.updateTable),
      where: where(WellnessCheck.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WellnessCheck.t),
      orderByList: orderByList?.call(WellnessCheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [WellnessCheck]s in the list and returns the deleted rows.
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
  Future<List<WellnessCheck>> delete(
    _is.DatabaseSession session,
    List<WellnessCheck> rows, {
    _is.OrderByBuilder<WellnessCheckTable>? orderBy,
    _is.OrderByListBuilder<WellnessCheckTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<WellnessCheck>(
      rows,
      orderBy: orderBy?.call(WellnessCheck.t),
      orderByList: orderByList?.call(WellnessCheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [WellnessCheck].
  Future<WellnessCheck> deleteRow(
    _is.DatabaseSession session,
    WellnessCheck row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WellnessCheck>(
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
  Future<List<WellnessCheck>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WellnessCheckTable> where,
    _is.OrderByBuilder<WellnessCheckTable>? orderBy,
    _is.OrderByListBuilder<WellnessCheckTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<WellnessCheck>(
      where: where(WellnessCheck.t),
      orderBy: orderBy?.call(WellnessCheck.t),
      orderByList: orderByList?.call(WellnessCheck.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WellnessCheckTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<WellnessCheck>(
      where: where?.call(WellnessCheck.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [WellnessCheck] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WellnessCheckTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<WellnessCheck>(
      where: where(WellnessCheck.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
