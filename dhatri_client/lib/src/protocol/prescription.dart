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
import 'prescription_status.dart' as _igud7pae;

abstract class Prescription
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Prescription._({
    this.id,
    required this.patientId,
    required this.storageId,
    required this.path,
    required this.status,
    this.extractedJson,
    this.error,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Prescription({
    int? id,
    required int patientId,
    required String storageId,
    required String path,
    required _igud7pae.PrescriptionStatus status,
    String? extractedJson,
    String? error,
    DateTime? createdAt,
  }) = _PrescriptionImpl;

  factory Prescription.fromJson(Map<String, dynamic> jsonSerialization) {
    return Prescription(
      id: jsonSerialization['id'] as int?,
      patientId: jsonSerialization['patientId'] as int,
      storageId: jsonSerialization['storageId'] as String,
      path: jsonSerialization['path'] as String,
      status: _igud7pae.PrescriptionStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      extractedJson: jsonSerialization['extractedJson'] as String?,
      error: jsonSerialization['error'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int patientId;

  String storageId;

  String path;

  _igud7pae.PrescriptionStatus status;

  String? extractedJson;

  String? error;

  DateTime createdAt;

  /// Returns a shallow copy of this [Prescription]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Prescription copyWith({
    int? id,
    int? patientId,
    String? storageId,
    String? path,
    _igud7pae.PrescriptionStatus? status,
    String? extractedJson,
    String? error,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Prescription',
      if (id != null) 'id': id,
      'patientId': patientId,
      'storageId': storageId,
      'path': path,
      'status': status.toJson(),
      if (extractedJson != null) 'extractedJson': extractedJson,
      if (error != null) 'error': error,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Prescription',
      if (id != null) 'id': id,
      'patientId': patientId,
      'storageId': storageId,
      'path': path,
      'status': status.toJson(),
      if (extractedJson != null) 'extractedJson': extractedJson,
      if (error != null) 'error': error,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PrescriptionImpl extends Prescription {
  _PrescriptionImpl({
    int? id,
    required int patientId,
    required String storageId,
    required String path,
    required _igud7pae.PrescriptionStatus status,
    String? extractedJson,
    String? error,
    DateTime? createdAt,
  }) : super._(
         id: id,
         patientId: patientId,
         storageId: storageId,
         path: path,
         status: status,
         extractedJson: extractedJson,
         error: error,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Prescription]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Prescription copyWith({
    Object? id = _Undefined,
    int? patientId,
    String? storageId,
    String? path,
    _igud7pae.PrescriptionStatus? status,
    Object? extractedJson = _Undefined,
    Object? error = _Undefined,
    DateTime? createdAt,
  }) {
    return Prescription(
      id: id is int? ? id : this.id,
      patientId: patientId ?? this.patientId,
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      status: status ?? this.status,
      extractedJson: extractedJson is String?
          ? extractedJson
          : this.extractedJson,
      error: error is String? ? error : this.error,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
