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
import 'package:dhatri_client/src/protocol/protocol.dart' as _i3jg2yd6;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class Medication
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
      times: _i3jg2yd6.Protocol().deserialize<List<String>>(
        jsonSerialization['times'],
      ),
      startDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['endDate'],
      ),
      active: jsonSerialization['active'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['active']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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

  /// Returns a shallow copy of this [Medication]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
