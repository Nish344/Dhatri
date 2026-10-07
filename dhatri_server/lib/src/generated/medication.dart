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

abstract class Medication
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Medication._({
    this.id,
    required this.patientId,
    required this.prescriptionId,
    required this.name,
    this.strength,
    required this.doseText,
    this.instructions,
    required this.times,
    required this.startDate,
    required this.endDate,
    bool? active,
  }) : active = active ?? true;

  factory Medication({
    int? id,
    required int patientId,
    required int prescriptionId,
    required String name,
    String? strength,
    required String doseText,
    String? instructions,
    required List<String> times,
    required DateTime startDate,
    required DateTime endDate,
    bool? active,
  }) = _MedicationImpl;

  factory Medication.fromJson(Map<String, dynamic> jsonSerialization) {
    return Medication(
      id: jsonSerialization['id'] as int?,
      patientId: jsonSerialization['patientId'] as int,
      prescriptionId: jsonSerialization['prescriptionId'] as int,
      name: jsonSerialization['name'] as String,
      strength: jsonSerialization['strength'] as String?,
      doseText: jsonSerialization['doseText'] as String,
      instructions: jsonSerialization['instructions'] as String?,
      times: _iig3g4e3.Protocol().deserialize<List<String>>(
        jsonSerialization['times'],
      ),
      startDate: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: _is.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      active: jsonSerialization['active'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['active']),
    );
  }

  static final t = MedicationTable();

  static const db = MedicationRepository._();

  @override
  int? id;

  int patientId;

  int prescriptionId;

  String name;

  String? strength;

  String doseText;

  String? instructions;

  List<String> times;

  DateTime startDate;

  DateTime endDate;

  bool active;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Medication]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Medication copyWith({
    int? id,
    int? patientId,
    int? prescriptionId,
    String? name,
    String? strength,
    String? doseText,
    String? instructions,
    List<String>? times,
    DateTime? startDate,
    DateTime? endDate,
    bool? active,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Medication',
      if (id != null) 'id': id,
      'patientId': patientId,
      'prescriptionId': prescriptionId,
      'name': name,
      if (strength != null) 'strength': strength,
      'doseText': doseText,
      if (instructions != null) 'instructions': instructions,
      'times': times.toJson(),
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'active': active,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Medication',
      if (id != null) 'id': id,
      'patientId': patientId,
      'prescriptionId': prescriptionId,
      'name': name,
      if (strength != null) 'strength': strength,
      'doseText': doseText,
      if (instructions != null) 'instructions': instructions,
      'times': times.toJson(),
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'active': active,
    };
  }

  static MedicationInclude include() {
    return MedicationInclude._();
  }

  static MedicationIncludeList includeList({
    _is.WhereExpressionBuilder<MedicationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MedicationTable>? orderBy,
    _is.OrderByListBuilder<MedicationTable>? orderByList,
    MedicationInclude? include,
  }) {
    return MedicationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Medication.t),
      orderByList: orderByList?.call(Medication.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MedicationImpl extends Medication {
  _MedicationImpl({
    int? id,
    required int patientId,
    required int prescriptionId,
    required String name,
    String? strength,
    required String doseText,
    String? instructions,
    required List<String> times,
    required DateTime startDate,
    required DateTime endDate,
    bool? active,
  }) : super._(
         id: id,
         patientId: patientId,
         prescriptionId: prescriptionId,
         name: name,
         strength: strength,
         doseText: doseText,
         instructions: instructions,
         times: times,
         startDate: startDate,
         endDate: endDate,
         active: active,
       );

  /// Returns a shallow copy of this [Medication]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Medication copyWith({
    Object? id = _Undefined,
    int? patientId,
    int? prescriptionId,
    String? name,
    Object? strength = _Undefined,
    String? doseText,
    Object? instructions = _Undefined,
    List<String>? times,
    DateTime? startDate,
    DateTime? endDate,
    bool? active,
  }) {
    return Medication(
      id: id is int? ? id : this.id,
      patientId: patientId ?? this.patientId,
      prescriptionId: prescriptionId ?? this.prescriptionId,
      name: name ?? this.name,
      strength: strength is String? ? strength : this.strength,
      doseText: doseText ?? this.doseText,
      instructions: instructions is String? ? instructions : this.instructions,
      times: times ?? this.times.map((e0) => e0).toList(),
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      active: active ?? this.active,
    );
  }
}

class MedicationUpdateTable extends _is.UpdateTable<MedicationTable> {
  MedicationUpdateTable(super.table);

  _is.ColumnValue<int, int> patientId(int value) => _is.ColumnValue(
    table.patientId,
    value,
  );

  _is.ColumnValue<int, int> prescriptionId(int value) => _is.ColumnValue(
    table.prescriptionId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> strength(String? value) => _is.ColumnValue(
    table.strength,
    value,
  );

  _is.ColumnValue<String, String> doseText(String value) => _is.ColumnValue(
    table.doseText,
    value,
  );

  _is.ColumnValue<String, String> instructions(String? value) =>
      _is.ColumnValue(
        table.instructions,
        value,
      );

  _is.ColumnValue<List<String>, List<String>> times(List<String> value) =>
      _is.ColumnValue(
        table.times,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> startDate(DateTime value) =>
      _is.ColumnValue(
        table.startDate,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> endDate(DateTime value) =>
      _is.ColumnValue(
        table.endDate,
        value,
      );

  _is.ColumnValue<bool, bool> active(bool value) => _is.ColumnValue(
    table.active,
    value,
  );
}

class MedicationTable extends _is.Table<int?> {
  MedicationTable({super.tableRelation}) : super(tableName: 'medication') {
    updateTable = MedicationUpdateTable(this);
    patientId = _is.ColumnInt(
      'patientId',
      this,
    );
    prescriptionId = _is.ColumnInt(
      'prescriptionId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    strength = _is.ColumnString(
      'strength',
      this,
    );
    doseText = _is.ColumnString(
      'doseText',
      this,
    );
    instructions = _is.ColumnString(
      'instructions',
      this,
    );
    times = _is.ColumnSerializable<List<String>>(
      'times',
      this,
    );
    startDate = _is.ColumnDateTime(
      'startDate',
      this,
    );
    endDate = _is.ColumnDateTime(
      'endDate',
      this,
    );
    active = _is.ColumnBool(
      'active',
      this,
      hasDefault: true,
    );
  }

  late final MedicationUpdateTable updateTable;

  late final _is.ColumnInt patientId;

  late final _is.ColumnInt prescriptionId;

  late final _is.ColumnString name;

  late final _is.ColumnString strength;

  late final _is.ColumnString doseText;

  late final _is.ColumnString instructions;

  late final _is.ColumnSerializable<List<String>> times;

  late final _is.ColumnDateTime startDate;

  late final _is.ColumnDateTime endDate;

  late final _is.ColumnBool active;

  @override
  List<_is.Column> get columns => [
    id,
    patientId,
    prescriptionId,
    name,
    strength,
    doseText,
    instructions,
    times,
    startDate,
    endDate,
    active,
  ];
}

class MedicationInclude extends _is.IncludeObject {
  MedicationInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Medication.t;
}

class MedicationIncludeList extends _is.IncludeList {
  MedicationIncludeList._({
    _is.WhereExpressionBuilder<MedicationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Medication.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Medication.t;
}

class MedicationRepository {
  const MedicationRepository._();

  /// Returns a list of [Medication]s matching the given query parameters.
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
  Future<List<Medication>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MedicationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MedicationTable>? orderBy,
    _is.OrderByListBuilder<MedicationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Medication>(
      where: where?.call(Medication.t),
      orderBy: orderBy?.call(Medication.t),
      orderByList: orderByList?.call(Medication.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Medication] matching the given query parameters.
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
  Future<Medication?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MedicationTable>? where,
    int? offset,
    _is.OrderByBuilder<MedicationTable>? orderBy,
    _is.OrderByListBuilder<MedicationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Medication>(
      where: where?.call(Medication.t),
      orderBy: orderBy?.call(Medication.t),
      orderByList: orderByList?.call(Medication.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Medication] by its [id] or null if no such row exists.
  Future<Medication?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Medication>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Medication]s in the list and returns the inserted rows.
  ///
  /// The returned [Medication]s will have their `id` fields set.
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
  Future<List<Medication>> insert(
    _is.DatabaseSession session,
    List<Medication> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Medication>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Medication] and returns the inserted row.
  ///
  /// The returned [Medication] will have its `id` field set.
  Future<Medication> insertRow(
    _is.DatabaseSession session,
    Medication row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Medication>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Medication]s in the list and returns the resulting rows.
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
  /// The returned [Medication]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Medication>> upsert(
    _is.DatabaseSession session,
    List<Medication> rows, {
    required _is.ColumnSelections<MedicationTable> conflictColumns,
    _is.ColumnSelections<MedicationTable>? updateColumns,
    _is.WhereExpressionBuilder<MedicationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Medication>(
      rows,
      conflictColumns: conflictColumns(Medication.t),
      updateColumns: updateColumns?.call(Medication.t),
      updateWhere: updateWhere?.call(Medication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Medication] and returns the resulting row.
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
  /// The returned [Medication] will have its `id` field set.
  Future<Medication?> upsertRow(
    _is.DatabaseSession session,
    Medication row, {
    required _is.ColumnSelections<MedicationTable> conflictColumns,
    _is.ColumnSelections<MedicationTable>? updateColumns,
    _is.WhereExpressionBuilder<MedicationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Medication>(
      row,
      conflictColumns: conflictColumns(Medication.t),
      updateColumns: updateColumns?.call(Medication.t),
      updateWhere: updateWhere?.call(Medication.t),
      transaction: transaction,
    );
  }

  /// Updates all [Medication]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Medication>> update(
    _is.DatabaseSession session,
    List<Medication> rows, {
    _is.ColumnSelections<MedicationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Medication>(
      rows,
      columns: columns?.call(Medication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Medication]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Medication> updateRow(
    _is.DatabaseSession session,
    Medication row, {
    _is.ColumnSelections<MedicationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Medication>(
      row,
      columns: columns?.call(Medication.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Medication] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Medication?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<MedicationUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Medication>(
      id,
      columnValues: columnValues(Medication.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Medication]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Medication>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<MedicationUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<MedicationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MedicationTable>? orderBy,
    _is.OrderByListBuilder<MedicationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Medication>(
      columnValues: columnValues(Medication.t.updateTable),
      where: where(Medication.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Medication.t),
      orderByList: orderByList?.call(Medication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Medication]s in the list and returns the deleted rows.
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
  Future<List<Medication>> delete(
    _is.DatabaseSession session,
    List<Medication> rows, {
    _is.OrderByBuilder<MedicationTable>? orderBy,
    _is.OrderByListBuilder<MedicationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Medication>(
      rows,
      orderBy: orderBy?.call(Medication.t),
      orderByList: orderByList?.call(Medication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Medication].
  Future<Medication> deleteRow(
    _is.DatabaseSession session,
    Medication row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Medication>(
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
  Future<List<Medication>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MedicationTable> where,
    _is.OrderByBuilder<MedicationTable>? orderBy,
    _is.OrderByListBuilder<MedicationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Medication>(
      where: where(Medication.t),
      orderBy: orderBy?.call(Medication.t),
      orderByList: orderByList?.call(Medication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MedicationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Medication>(
      where: where?.call(Medication.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Medication] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MedicationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Medication>(
      where: where(Medication.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
