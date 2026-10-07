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
import 'dose_status.dart' as _ihnxdm4b;

abstract class DoseEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
      scheduledAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['scheduledAt'],
      ),
      status: _ihnxdm4b.DoseStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      remindedAt: jsonSerialization['remindedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['remindedAt'],
            ),
      takenAt: jsonSerialization['takenAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['takenAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int patientId;

  int medicationId;

  DateTime scheduledAt;

  _ihnxdm4b.DoseStatus status;

  DateTime? remindedAt;

  DateTime? takenAt;

  /// Returns a shallow copy of this [DoseEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
