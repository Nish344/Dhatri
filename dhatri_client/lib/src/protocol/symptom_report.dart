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

abstract class SymptomReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['reportedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int patientId;

  int checkId;

  String symptom;

  int severity;

  DateTime reportedAt;

  /// Returns a shallow copy of this [SymptomReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
