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
import 'dose_event.dart' as _i6sqb1u1;
import 'patient_state.dart' as _ik43n87i;
import 'profile.dart' as _ilz0o8l0;

abstract class PatientStatus
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PatientStatus._({
    required this.patient,
    required this.state,
    required this.headline,
    this.nextDose,
    required this.openAlerts,
  });

  factory PatientStatus({
    required _ilz0o8l0.Profile patient,
    required _ik43n87i.PatientState state,
    required String headline,
    _i6sqb1u1.DoseEvent? nextDose,
    required int openAlerts,
  }) = _PatientStatusImpl;

  factory PatientStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return PatientStatus(
      patient: _i3jg2yd6.Protocol().deserialize<_ilz0o8l0.Profile>(
        jsonSerialization['patient'],
      ),
      state: _ik43n87i.PatientState.fromJson(
        (jsonSerialization['state'] as String),
      ),
      headline: jsonSerialization['headline'] as String,
      nextDose: jsonSerialization['nextDose'] == null
          ? null
          : _i3jg2yd6.Protocol().deserialize<_i6sqb1u1.DoseEvent>(
              jsonSerialization['nextDose'],
            ),
      openAlerts: jsonSerialization['openAlerts'] as int,
    );
  }

  _ilz0o8l0.Profile patient;

  _ik43n87i.PatientState state;

  String headline;

  _i6sqb1u1.DoseEvent? nextDose;

  int openAlerts;

  /// Returns a shallow copy of this [PatientStatus]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PatientStatus copyWith({
    _ilz0o8l0.Profile? patient,
    _ik43n87i.PatientState? state,
    String? headline,
    _i6sqb1u1.DoseEvent? nextDose,
    int? openAlerts,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PatientStatus',
      'patient': patient.toJson(),
      'state': state.toJson(),
      'headline': headline,
      if (nextDose != null) 'nextDose': nextDose?.toJson(),
      'openAlerts': openAlerts,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PatientStatus',
      'patient': patient.toJsonForProtocol(),
      'state': state.toJson(),
      'headline': headline,
      if (nextDose != null) 'nextDose': nextDose?.toJsonForProtocol(),
      'openAlerts': openAlerts,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PatientStatusImpl extends PatientStatus {
  _PatientStatusImpl({
    required _ilz0o8l0.Profile patient,
    required _ik43n87i.PatientState state,
    required String headline,
    _i6sqb1u1.DoseEvent? nextDose,
    required int openAlerts,
  }) : super._(
         patient: patient,
         state: state,
         headline: headline,
         nextDose: nextDose,
         openAlerts: openAlerts,
       );

  /// Returns a shallow copy of this [PatientStatus]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PatientStatus copyWith({
    _ilz0o8l0.Profile? patient,
    _ik43n87i.PatientState? state,
    String? headline,
    Object? nextDose = _Undefined,
    int? openAlerts,
  }) {
    return PatientStatus(
      patient: patient ?? this.patient.copyWith(),
      state: state ?? this.state,
      headline: headline ?? this.headline,
      nextDose: nextDose is _i6sqb1u1.DoseEvent?
          ? nextDose
          : this.nextDose?.copyWith(),
      openAlerts: openAlerts ?? this.openAlerts,
    );
  }
}
