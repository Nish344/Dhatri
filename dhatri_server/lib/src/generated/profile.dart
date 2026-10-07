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
import 'role.dart' as _i65v1yji;

abstract class Profile
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Profile._({
    this.id,
    this.authUserId,
    required this.name,
    required this.role,
    this.age,
    this.phone,
    this.caregiverId,
    this.doctorId,
    this.linkCode,
  });

  factory Profile({
    int? id,
    String? authUserId,
    required String name,
    required _i65v1yji.Role role,
    int? age,
    String? phone,
    int? caregiverId,
    int? doctorId,
    String? linkCode,
  }) = _ProfileImpl;

  factory Profile.fromJson(Map<String, dynamic> jsonSerialization) {
    return Profile(
      id: jsonSerialization['id'] as int?,
      authUserId: jsonSerialization['authUserId'] as String?,
      name: jsonSerialization['name'] as String,
      role: _i65v1yji.Role.fromJson((jsonSerialization['role'] as String)),
      age: jsonSerialization['age'] as int?,
      phone: jsonSerialization['phone'] as String?,
      caregiverId: jsonSerialization['caregiverId'] as int?,
      doctorId: jsonSerialization['doctorId'] as int?,
      linkCode: jsonSerialization['linkCode'] as String?,
    );
  }

  static final t = ProfileTable();

  static const db = ProfileRepository._();

  @override
  int? id;

  String? authUserId;

  String name;

  _i65v1yji.Role role;

  int? age;

  String? phone;

  int? caregiverId;

  int? doctorId;

  String? linkCode;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Profile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Profile copyWith({
    int? id,
    String? authUserId,
    String? name,
    _i65v1yji.Role? role,
    int? age,
    String? phone,
    int? caregiverId,
    int? doctorId,
    String? linkCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Profile',
      if (id != null) 'id': id,
      if (authUserId != null) 'authUserId': authUserId,
      'name': name,
      'role': role.toJson(),
      if (age != null) 'age': age,
      if (phone != null) 'phone': phone,
      if (caregiverId != null) 'caregiverId': caregiverId,
      if (doctorId != null) 'doctorId': doctorId,
      if (linkCode != null) 'linkCode': linkCode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Profile',
      if (id != null) 'id': id,
      if (authUserId != null) 'authUserId': authUserId,
      'name': name,
      'role': role.toJson(),
      if (age != null) 'age': age,
      if (phone != null) 'phone': phone,
      if (caregiverId != null) 'caregiverId': caregiverId,
      if (doctorId != null) 'doctorId': doctorId,
      if (linkCode != null) 'linkCode': linkCode,
    };
  }

  static ProfileInclude include() {
    return ProfileInclude._();
  }

  static ProfileIncludeList includeList({
    _is.WhereExpressionBuilder<ProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProfileTable>? orderBy,
    _is.OrderByListBuilder<ProfileTable>? orderByList,
    ProfileInclude? include,
  }) {
    return ProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Profile.t),
      orderByList: orderByList?.call(Profile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProfileImpl extends Profile {
  _ProfileImpl({
    int? id,
    String? authUserId,
    required String name,
    required _i65v1yji.Role role,
    int? age,
    String? phone,
    int? caregiverId,
    int? doctorId,
    String? linkCode,
  }) : super._(
         id: id,
         authUserId: authUserId,
         name: name,
         role: role,
         age: age,
         phone: phone,
         caregiverId: caregiverId,
         doctorId: doctorId,
         linkCode: linkCode,
       );

  /// Returns a shallow copy of this [Profile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Profile copyWith({
    Object? id = _Undefined,
    Object? authUserId = _Undefined,
    String? name,
    _i65v1yji.Role? role,
    Object? age = _Undefined,
    Object? phone = _Undefined,
    Object? caregiverId = _Undefined,
    Object? doctorId = _Undefined,
    Object? linkCode = _Undefined,
  }) {
    return Profile(
      id: id is int? ? id : this.id,
      authUserId: authUserId is String? ? authUserId : this.authUserId,
      name: name ?? this.name,
      role: role ?? this.role,
      age: age is int? ? age : this.age,
      phone: phone is String? ? phone : this.phone,
      caregiverId: caregiverId is int? ? caregiverId : this.caregiverId,
      doctorId: doctorId is int? ? doctorId : this.doctorId,
      linkCode: linkCode is String? ? linkCode : this.linkCode,
    );
  }
}

class ProfileUpdateTable extends _is.UpdateTable<ProfileTable> {
  ProfileUpdateTable(super.table);

  _is.ColumnValue<String, String> authUserId(String? value) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<_i65v1yji.Role, _i65v1yji.Role> role(_i65v1yji.Role value) =>
      _is.ColumnValue(
        table.role,
        value,
      );

  _is.ColumnValue<int, int> age(int? value) => _is.ColumnValue(
    table.age,
    value,
  );

  _is.ColumnValue<String, String> phone(String? value) => _is.ColumnValue(
    table.phone,
    value,
  );

  _is.ColumnValue<int, int> caregiverId(int? value) => _is.ColumnValue(
    table.caregiverId,
    value,
  );

  _is.ColumnValue<int, int> doctorId(int? value) => _is.ColumnValue(
    table.doctorId,
    value,
  );

  _is.ColumnValue<String, String> linkCode(String? value) => _is.ColumnValue(
    table.linkCode,
    value,
  );
}

class ProfileTable extends _is.Table<int?> {
  ProfileTable({super.tableRelation}) : super(tableName: 'profile') {
    updateTable = ProfileUpdateTable(this);
    authUserId = _is.ColumnString(
      'authUserId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    role = _is.ColumnEnum(
      'role',
      this,
      _is.EnumSerialization.byName,
    );
    age = _is.ColumnInt(
      'age',
      this,
    );
    phone = _is.ColumnString(
      'phone',
      this,
    );
    caregiverId = _is.ColumnInt(
      'caregiverId',
      this,
    );
    doctorId = _is.ColumnInt(
      'doctorId',
      this,
    );
    linkCode = _is.ColumnString(
      'linkCode',
      this,
    );
  }

  late final ProfileUpdateTable updateTable;

  late final _is.ColumnString authUserId;

  late final _is.ColumnString name;

  late final _is.ColumnEnum<_i65v1yji.Role> role;

  late final _is.ColumnInt age;

  late final _is.ColumnString phone;

  late final _is.ColumnInt caregiverId;

  late final _is.ColumnInt doctorId;

  late final _is.ColumnString linkCode;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    name,
    role,
    age,
    phone,
    caregiverId,
    doctorId,
    linkCode,
  ];
}

class ProfileInclude extends _is.IncludeObject {
  ProfileInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Profile.t;
}

class ProfileIncludeList extends _is.IncludeList {
  ProfileIncludeList._({
    _is.WhereExpressionBuilder<ProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Profile.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Profile.t;
}

class ProfileRepository {
  const ProfileRepository._();

  /// Returns a list of [Profile]s matching the given query parameters.
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
  Future<List<Profile>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProfileTable>? orderBy,
    _is.OrderByListBuilder<ProfileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Profile>(
      where: where?.call(Profile.t),
      orderBy: orderBy?.call(Profile.t),
      orderByList: orderByList?.call(Profile.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Profile] matching the given query parameters.
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
  Future<Profile?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProfileTable>? where,
    int? offset,
    _is.OrderByBuilder<ProfileTable>? orderBy,
    _is.OrderByListBuilder<ProfileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Profile>(
      where: where?.call(Profile.t),
      orderBy: orderBy?.call(Profile.t),
      orderByList: orderByList?.call(Profile.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Profile] by its [id] or null if no such row exists.
  Future<Profile?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Profile>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Profile]s in the list and returns the inserted rows.
  ///
  /// The returned [Profile]s will have their `id` fields set.
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
  Future<List<Profile>> insert(
    _is.DatabaseSession session,
    List<Profile> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Profile>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Profile] and returns the inserted row.
  ///
  /// The returned [Profile] will have its `id` field set.
  Future<Profile> insertRow(
    _is.DatabaseSession session,
    Profile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Profile>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Profile]s in the list and returns the resulting rows.
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
  /// The returned [Profile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Profile>> upsert(
    _is.DatabaseSession session,
    List<Profile> rows, {
    required _is.ColumnSelections<ProfileTable> conflictColumns,
    _is.ColumnSelections<ProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<ProfileTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Profile>(
      rows,
      conflictColumns: conflictColumns(Profile.t),
      updateColumns: updateColumns?.call(Profile.t),
      updateWhere: updateWhere?.call(Profile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Profile] and returns the resulting row.
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
  /// The returned [Profile] will have its `id` field set.
  Future<Profile?> upsertRow(
    _is.DatabaseSession session,
    Profile row, {
    required _is.ColumnSelections<ProfileTable> conflictColumns,
    _is.ColumnSelections<ProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<ProfileTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Profile>(
      row,
      conflictColumns: conflictColumns(Profile.t),
      updateColumns: updateColumns?.call(Profile.t),
      updateWhere: updateWhere?.call(Profile.t),
      transaction: transaction,
    );
  }

  /// Updates all [Profile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Profile>> update(
    _is.DatabaseSession session,
    List<Profile> rows, {
    _is.ColumnSelections<ProfileTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Profile>(
      rows,
      columns: columns?.call(Profile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Profile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Profile> updateRow(
    _is.DatabaseSession session,
    Profile row, {
    _is.ColumnSelections<ProfileTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Profile>(
      row,
      columns: columns?.call(Profile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Profile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Profile?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ProfileUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Profile>(
      id,
      columnValues: columnValues(Profile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Profile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Profile>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProfileUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ProfileTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProfileTable>? orderBy,
    _is.OrderByListBuilder<ProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Profile>(
      columnValues: columnValues(Profile.t.updateTable),
      where: where(Profile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Profile.t),
      orderByList: orderByList?.call(Profile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Profile]s in the list and returns the deleted rows.
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
  Future<List<Profile>> delete(
    _is.DatabaseSession session,
    List<Profile> rows, {
    _is.OrderByBuilder<ProfileTable>? orderBy,
    _is.OrderByListBuilder<ProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Profile>(
      rows,
      orderBy: orderBy?.call(Profile.t),
      orderByList: orderByList?.call(Profile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Profile].
  Future<Profile> deleteRow(
    _is.DatabaseSession session,
    Profile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Profile>(
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
  Future<List<Profile>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProfileTable> where,
    _is.OrderByBuilder<ProfileTable>? orderBy,
    _is.OrderByListBuilder<ProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Profile>(
      where: where(Profile.t),
      orderBy: orderBy?.call(Profile.t),
      orderByList: orderByList?.call(Profile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProfileTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Profile>(
      where: where?.call(Profile.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Profile] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProfileTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Profile>(
      where: where(Profile.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
