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
import 'alert.dart' as _iqmz6gj4;
import 'profile.dart' as _ilz0o8l0;
import 'symptom_count.dart' as _i5cnrx2s;
import 'wellness_check.dart' as _ita6sj68;

abstract class PatientInsight
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PatientInsight._({
    required this.patient,
    this.adherencePct,
    this.prevAdherencePct,
    required this.dosesTaken,
    required this.dosesMissed,
    required this.checkIns,
    required this.symptoms,
    required this.openAlerts,
    required this.reviewRecommended,
    required this.aiSummary,
    this.latestCheck,
    required this.generatedAt,
  });

  factory PatientInsight({
    required _ilz0o8l0.Profile patient,
    int? adherencePct,
    int? prevAdherencePct,
    required int dosesTaken,
    required int dosesMissed,
    required int checkIns,
    required List<_i5cnrx2s.SymptomCount> symptoms,
    required List<_iqmz6gj4.Alert> openAlerts,
    required bool reviewRecommended,
    required String aiSummary,
    _ita6sj68.WellnessCheck? latestCheck,
    required DateTime generatedAt,
  }) = _PatientInsightImpl;

  factory PatientInsight.fromJson(Map<String, dynamic> jsonSerialization) {
    return PatientInsight(
      patient: _i3jg2yd6.Protocol().deserialize<_ilz0o8l0.Profile>(
        jsonSerialization['patient'],
      ),
      adherencePct: jsonSerialization['adherencePct'] as int?,
      prevAdherencePct: jsonSerialization['prevAdherencePct'] as int?,
      dosesTaken: jsonSerialization['dosesTaken'] as int,
      dosesMissed: jsonSerialization['dosesMissed'] as int,
      checkIns: jsonSerialization['checkIns'] as int,
      symptoms: _i3jg2yd6.Protocol().deserialize<List<_i5cnrx2s.SymptomCount>>(
        jsonSerialization['symptoms'],
      ),
      openAlerts: _i3jg2yd6.Protocol().deserialize<List<_iqmz6gj4.Alert>>(
        jsonSerialization['openAlerts'],
      ),
      reviewRecommended: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['reviewRecommended'],
      ),
      aiSummary: jsonSerialization['aiSummary'] as String,
      latestCheck: jsonSerialization['latestCheck'] == null
          ? null
          : _i3jg2yd6.Protocol().deserialize<_ita6sj68.WellnessCheck>(
              jsonSerialization['latestCheck'],
            ),
      generatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
    );
  }

  _ilz0o8l0.Profile patient;

  int? adherencePct;

  int? prevAdherencePct;

  int dosesTaken;

  int dosesMissed;

  int checkIns;

  List<_i5cnrx2s.SymptomCount> symptoms;

  List<_iqmz6gj4.Alert> openAlerts;

  bool reviewRecommended;

  String aiSummary;

  _ita6sj68.WellnessCheck? latestCheck;

  DateTime generatedAt;

  /// Returns a shallow copy of this [PatientInsight]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PatientInsight copyWith({
    _ilz0o8l0.Profile? patient,
    int? adherencePct,
    int? prevAdherencePct,
    int? dosesTaken,
    int? dosesMissed,
    int? checkIns,
    List<_i5cnrx2s.SymptomCount>? symptoms,
    List<_iqmz6gj4.Alert>? openAlerts,
    bool? reviewRecommended,
    String? aiSummary,
    _ita6sj68.WellnessCheck? latestCheck,
    DateTime? generatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PatientInsight',
      'patient': patient.toJson(),
      if (adherencePct != null) 'adherencePct': adherencePct,
      if (prevAdherencePct != null) 'prevAdherencePct': prevAdherencePct,
      'dosesTaken': dosesTaken,
      'dosesMissed': dosesMissed,
      'checkIns': checkIns,
      'symptoms': symptoms.toJson(valueToJson: (v) => v.toJson()),
      'openAlerts': openAlerts.toJson(valueToJson: (v) => v.toJson()),
      'reviewRecommended': reviewRecommended,
      'aiSummary': aiSummary,
      if (latestCheck != null) 'latestCheck': latestCheck?.toJson(),
      'generatedAt': generatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PatientInsight',
      'patient': patient.toJsonForProtocol(),
      if (adherencePct != null) 'adherencePct': adherencePct,
      if (prevAdherencePct != null) 'prevAdherencePct': prevAdherencePct,
      'dosesTaken': dosesTaken,
      'dosesMissed': dosesMissed,
      'checkIns': checkIns,
      'symptoms': symptoms.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'openAlerts': openAlerts.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'reviewRecommended': reviewRecommended,
      'aiSummary': aiSummary,
      if (latestCheck != null) 'latestCheck': latestCheck?.toJsonForProtocol(),
      'generatedAt': generatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PatientInsightImpl extends PatientInsight {
  _PatientInsightImpl({
    required _ilz0o8l0.Profile patient,
    int? adherencePct,
    int? prevAdherencePct,
    required int dosesTaken,
    required int dosesMissed,
    required int checkIns,
    required List<_i5cnrx2s.SymptomCount> symptoms,
    required List<_iqmz6gj4.Alert> openAlerts,
    required bool reviewRecommended,
    required String aiSummary,
    _ita6sj68.WellnessCheck? latestCheck,
    required DateTime generatedAt,
  }) : super._(
         patient: patient,
         adherencePct: adherencePct,
         prevAdherencePct: prevAdherencePct,
         dosesTaken: dosesTaken,
         dosesMissed: dosesMissed,
         checkIns: checkIns,
         symptoms: symptoms,
         openAlerts: openAlerts,
         reviewRecommended: reviewRecommended,
         aiSummary: aiSummary,
         latestCheck: latestCheck,
         generatedAt: generatedAt,
       );

  /// Returns a shallow copy of this [PatientInsight]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PatientInsight copyWith({
    _ilz0o8l0.Profile? patient,
    Object? adherencePct = _Undefined,
    Object? prevAdherencePct = _Undefined,
    int? dosesTaken,
    int? dosesMissed,
    int? checkIns,
    List<_i5cnrx2s.SymptomCount>? symptoms,
    List<_iqmz6gj4.Alert>? openAlerts,
    bool? reviewRecommended,
    String? aiSummary,
    Object? latestCheck = _Undefined,
    DateTime? generatedAt,
  }) {
    return PatientInsight(
      patient: patient ?? this.patient.copyWith(),
      adherencePct: adherencePct is int? ? adherencePct : this.adherencePct,
      prevAdherencePct: prevAdherencePct is int?
          ? prevAdherencePct
          : this.prevAdherencePct,
      dosesTaken: dosesTaken ?? this.dosesTaken,
      dosesMissed: dosesMissed ?? this.dosesMissed,
      checkIns: checkIns ?? this.checkIns,
      symptoms: symptoms ?? this.symptoms.map((e0) => e0.copyWith()).toList(),
      openAlerts:
          openAlerts ?? this.openAlerts.map((e0) => e0.copyWith()).toList(),
      reviewRecommended: reviewRecommended ?? this.reviewRecommended,
      aiSummary: aiSummary ?? this.aiSummary,
      latestCheck: latestCheck is _ita6sj68.WellnessCheck?
          ? latestCheck
          : this.latestCheck?.copyWith(),
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }
}
