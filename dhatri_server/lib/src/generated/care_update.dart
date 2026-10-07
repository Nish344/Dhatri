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
import 'alert.dart' as _iqmz6gj4;
import 'dose_event.dart' as _i6sqb1u1;
import 'prescription.dart' as _it6yrmua;
import 'wellness_check.dart' as _ita6sj68;

abstract class CareUpdate
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CareUpdate._({
    required this.patientId,
    this.doseEvent,
    this.alert,
    this.check,
    this.prescription,
  });

  factory CareUpdate({
    required int patientId,
    _i6sqb1u1.DoseEvent? doseEvent,
    _iqmz6gj4.Alert? alert,
    _ita6sj68.WellnessCheck? check,
    _it6yrmua.Prescription? prescription,
  }) = _CareUpdateImpl;

  factory CareUpdate.fromJson(Map<String, dynamic> jsonSerialization) {
    return CareUpdate(
      patientId: jsonSerialization['patientId'] as int,
      doseEvent: jsonSerialization['doseEvent'] == null
          ? null
          : _iig3g4e3.Protocol().deserialize<_i6sqb1u1.DoseEvent>(
              jsonSerialization['doseEvent'],
            ),
      alert: jsonSerialization['alert'] == null
          ? null
          : _iig3g4e3.Protocol().deserialize<_iqmz6gj4.Alert>(
              jsonSerialization['alert'],
            ),
      check: jsonSerialization['check'] == null
          ? null
          : _iig3g4e3.Protocol().deserialize<_ita6sj68.WellnessCheck>(
              jsonSerialization['check'],
            ),
      prescription: jsonSerialization['prescription'] == null
          ? null
          : _iig3g4e3.Protocol().deserialize<_it6yrmua.Prescription>(
              jsonSerialization['prescription'],
            ),
    );
  }

  int patientId;

  _i6sqb1u1.DoseEvent? doseEvent;

  _iqmz6gj4.Alert? alert;

  _ita6sj68.WellnessCheck? check;

  _it6yrmua.Prescription? prescription;

  /// Returns a shallow copy of this [CareUpdate]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CareUpdate copyWith({
    int? patientId,
    _i6sqb1u1.DoseEvent? doseEvent,
    _iqmz6gj4.Alert? alert,
    _ita6sj68.WellnessCheck? check,
    _it6yrmua.Prescription? prescription,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CareUpdate',
      'patientId': patientId,
      if (doseEvent != null) 'doseEvent': doseEvent?.toJson(),
      if (alert != null) 'alert': alert?.toJson(),
      if (check != null) 'check': check?.toJson(),
      if (prescription != null) 'prescription': prescription?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CareUpdate',
      'patientId': patientId,
      if (doseEvent != null) 'doseEvent': doseEvent?.toJsonForProtocol(),
      if (alert != null) 'alert': alert?.toJsonForProtocol(),
      if (check != null) 'check': check?.toJsonForProtocol(),
      if (prescription != null)
        'prescription': prescription?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CareUpdateImpl extends CareUpdate {
  _CareUpdateImpl({
    required int patientId,
    _i6sqb1u1.DoseEvent? doseEvent,
    _iqmz6gj4.Alert? alert,
    _ita6sj68.WellnessCheck? check,
    _it6yrmua.Prescription? prescription,
  }) : super._(
         patientId: patientId,
         doseEvent: doseEvent,
         alert: alert,
         check: check,
         prescription: prescription,
       );

  /// Returns a shallow copy of this [CareUpdate]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CareUpdate copyWith({
    int? patientId,
    Object? doseEvent = _Undefined,
    Object? alert = _Undefined,
    Object? check = _Undefined,
    Object? prescription = _Undefined,
  }) {
    return CareUpdate(
      patientId: patientId ?? this.patientId,
      doseEvent: doseEvent is _i6sqb1u1.DoseEvent?
          ? doseEvent
          : this.doseEvent?.copyWith(),
      alert: alert is _iqmz6gj4.Alert? ? alert : this.alert?.copyWith(),
      check: check is _ita6sj68.WellnessCheck? ? check : this.check?.copyWith(),
      prescription: prescription is _it6yrmua.Prescription?
          ? prescription
          : this.prescription?.copyWith(),
    );
  }
}
