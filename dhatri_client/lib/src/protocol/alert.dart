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
import 'alert_kind.dart' as _iyp0oawi;
import 'alert_priority.dart' as _iyhbjbo5;

abstract class Alert
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      acknowledgedAt: jsonSerialization['acknowledgedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['acknowledgedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int patientId;

  _iyp0oawi.AlertKind kind;

  _iyhbjbo5.AlertPriority priority;

  int? doseEventId;

  String? symptom;

  String message;

  DateTime createdAt;

  DateTime? acknowledgedAt;

  /// Returns a shallow copy of this [Alert]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
