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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'role.dart' as _i65v1yji;

abstract class Profile
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? authUserId;

  String name;

  _i65v1yji.Role role;

  int? age;

  String? phone;

  int? caregiverId;

  int? doctorId;

  String? linkCode;

  /// Returns a shallow copy of this [Profile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
