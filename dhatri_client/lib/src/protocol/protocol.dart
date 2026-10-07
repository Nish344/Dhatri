/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dhatri_client/src/protocol/dose_event.dart' as _iav2z4fb;
import 'package:dhatri_client/src/protocol/patient_status.dart' as _isnu78ia;
import 'package:dhatri_client/src/protocol/profile.dart' as _ii1trskb;
import 'package:dhatri_client/src/protocol/timeline_item.dart' as _ivovkn5g;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'alert.dart' as _iqmz6gj4;
import 'alert_kind.dart' as _iyp0oawi;
import 'alert_priority.dart' as _iyhbjbo5;
import 'care_update.dart' as _iq3u69l8;
import 'check_in_turn.dart' as _ij0fpt9l;
import 'check_status.dart' as _i152b260;
import 'check_trigger.dart' as _i06tdmkm;
import 'dose_event.dart' as _i6sqb1u1;
import 'dose_status.dart' as _ihnxdm4b;
import 'medication.dart' as _igwab1vy;
import 'medication_draft.dart' as _i32wz7ni;
import 'patient_insight.dart' as _iw8wpm46;
import 'patient_memory.dart' as _iibkifk1;
import 'patient_state.dart' as _ik43n87i;
import 'patient_status.dart' as _ifv8g6l9;
import 'prescription.dart' as _it6yrmua;
import 'prescription_status.dart' as _igud7pae;
import 'profile.dart' as _ilz0o8l0;
import 'role.dart' as _i65v1yji;
import 'symptom_count.dart' as _i5cnrx2s;
import 'symptom_report.dart' as _i44gi5vp;
import 'timeline_item.dart' as _ignyleo4;
import 'timeline_kind.dart' as _iez4s2vq;
import 'timeline_tone.dart' as _iwziokxg;
import 'upload_ticket.dart' as _in1yelte;
import 'wellness_check.dart' as _ita6sj68;
export 'alert.dart';
export 'alert_kind.dart';
export 'alert_priority.dart';
export 'care_update.dart';
export 'check_in_turn.dart';
export 'check_status.dart';
export 'check_trigger.dart';
export 'dose_event.dart';
export 'dose_status.dart';
export 'medication.dart';
export 'medication_draft.dart';
export 'patient_insight.dart';
export 'patient_memory.dart';
export 'patient_state.dart';
export 'patient_status.dart';
export 'prescription.dart';
export 'prescription_status.dart';
export 'profile.dart';
export 'role.dart';
export 'symptom_count.dart';
export 'symptom_report.dart';
export 'timeline_item.dart';
export 'timeline_kind.dart';
export 'timeline_tone.dart';
export 'upload_ticket.dart';
export 'wellness_check.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _iqmz6gj4.Alert) {
      return _iqmz6gj4.Alert.fromJson(data) as T;
    }
    if (t == _iyp0oawi.AlertKind) {
      return _iyp0oawi.AlertKind.fromJson(data) as T;
    }
    if (t == _iyhbjbo5.AlertPriority) {
      return _iyhbjbo5.AlertPriority.fromJson(data) as T;
    }
    if (t == _iq3u69l8.CareUpdate) {
      return _iq3u69l8.CareUpdate.fromJson(data) as T;
    }
    if (t == _ij0fpt9l.CheckInTurn) {
      return _ij0fpt9l.CheckInTurn.fromJson(data) as T;
    }
    if (t == _i152b260.CheckStatus) {
      return _i152b260.CheckStatus.fromJson(data) as T;
    }
    if (t == _i06tdmkm.CheckTrigger) {
      return _i06tdmkm.CheckTrigger.fromJson(data) as T;
    }
    if (t == _i6sqb1u1.DoseEvent) {
      return _i6sqb1u1.DoseEvent.fromJson(data) as T;
    }
    if (t == _ihnxdm4b.DoseStatus) {
      return _ihnxdm4b.DoseStatus.fromJson(data) as T;
    }
    if (t == _igwab1vy.Medication) {
      return _igwab1vy.Medication.fromJson(data) as T;
    }
    if (t == _i32wz7ni.MedicationDraft) {
      return _i32wz7ni.MedicationDraft.fromJson(data) as T;
    }
    if (t == _iw8wpm46.PatientInsight) {
      return _iw8wpm46.PatientInsight.fromJson(data) as T;
    }
    if (t == _iibkifk1.PatientMemory) {
      return _iibkifk1.PatientMemory.fromJson(data) as T;
    }
    if (t == _ik43n87i.PatientState) {
      return _ik43n87i.PatientState.fromJson(data) as T;
    }
    if (t == _ifv8g6l9.PatientStatus) {
      return _ifv8g6l9.PatientStatus.fromJson(data) as T;
    }
    if (t == _it6yrmua.Prescription) {
      return _it6yrmua.Prescription.fromJson(data) as T;
    }
    if (t == _igud7pae.PrescriptionStatus) {
      return _igud7pae.PrescriptionStatus.fromJson(data) as T;
    }
    if (t == _ilz0o8l0.Profile) {
      return _ilz0o8l0.Profile.fromJson(data) as T;
    }
    if (t == _i65v1yji.Role) {
      return _i65v1yji.Role.fromJson(data) as T;
    }
    if (t == _i5cnrx2s.SymptomCount) {
      return _i5cnrx2s.SymptomCount.fromJson(data) as T;
    }
    if (t == _i44gi5vp.SymptomReport) {
      return _i44gi5vp.SymptomReport.fromJson(data) as T;
    }
    if (t == _ignyleo4.TimelineItem) {
      return _ignyleo4.TimelineItem.fromJson(data) as T;
    }
    if (t == _iez4s2vq.TimelineKind) {
      return _iez4s2vq.TimelineKind.fromJson(data) as T;
    }
    if (t == _iwziokxg.TimelineTone) {
      return _iwziokxg.TimelineTone.fromJson(data) as T;
    }
    if (t == _in1yelte.UploadTicket) {
      return _in1yelte.UploadTicket.fromJson(data) as T;
    }
    if (t == _ita6sj68.WellnessCheck) {
      return _ita6sj68.WellnessCheck.fromJson(data) as T;
    }
    if (t == _isc.getType<_iqmz6gj4.Alert?>()) {
      return (data != null ? _iqmz6gj4.Alert.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iyp0oawi.AlertKind?>()) {
      return (data != null ? _iyp0oawi.AlertKind.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iyhbjbo5.AlertPriority?>()) {
      return (data != null ? _iyhbjbo5.AlertPriority.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iq3u69l8.CareUpdate?>()) {
      return (data != null ? _iq3u69l8.CareUpdate.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ij0fpt9l.CheckInTurn?>()) {
      return (data != null ? _ij0fpt9l.CheckInTurn.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i152b260.CheckStatus?>()) {
      return (data != null ? _i152b260.CheckStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i06tdmkm.CheckTrigger?>()) {
      return (data != null ? _i06tdmkm.CheckTrigger.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i6sqb1u1.DoseEvent?>()) {
      return (data != null ? _i6sqb1u1.DoseEvent.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ihnxdm4b.DoseStatus?>()) {
      return (data != null ? _ihnxdm4b.DoseStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_igwab1vy.Medication?>()) {
      return (data != null ? _igwab1vy.Medication.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i32wz7ni.MedicationDraft?>()) {
      return (data != null ? _i32wz7ni.MedicationDraft.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iw8wpm46.PatientInsight?>()) {
      return (data != null ? _iw8wpm46.PatientInsight.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iibkifk1.PatientMemory?>()) {
      return (data != null ? _iibkifk1.PatientMemory.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ik43n87i.PatientState?>()) {
      return (data != null ? _ik43n87i.PatientState.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ifv8g6l9.PatientStatus?>()) {
      return (data != null ? _ifv8g6l9.PatientStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_it6yrmua.Prescription?>()) {
      return (data != null ? _it6yrmua.Prescription.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_igud7pae.PrescriptionStatus?>()) {
      return (data != null ? _igud7pae.PrescriptionStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ilz0o8l0.Profile?>()) {
      return (data != null ? _ilz0o8l0.Profile.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i65v1yji.Role?>()) {
      return (data != null ? _i65v1yji.Role.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i5cnrx2s.SymptomCount?>()) {
      return (data != null ? _i5cnrx2s.SymptomCount.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i44gi5vp.SymptomReport?>()) {
      return (data != null ? _i44gi5vp.SymptomReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ignyleo4.TimelineItem?>()) {
      return (data != null ? _ignyleo4.TimelineItem.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iez4s2vq.TimelineKind?>()) {
      return (data != null ? _iez4s2vq.TimelineKind.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iwziokxg.TimelineTone?>()) {
      return (data != null ? _iwziokxg.TimelineTone.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_in1yelte.UploadTicket?>()) {
      return (data != null ? _in1yelte.UploadTicket.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ita6sj68.WellnessCheck?>()) {
      return (data != null ? _ita6sj68.WellnessCheck.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i5cnrx2s.SymptomCount>) {
      return (data as List)
              .map((e) => deserialize<_i5cnrx2s.SymptomCount>(e))
              .toList()
          as T;
    }
    if (t == List<_iqmz6gj4.Alert>) {
      return (data as List).map((e) => deserialize<_iqmz6gj4.Alert>(e)).toList()
          as T;
    }
    if (t == _isc.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_iav2z4fb.DoseEvent>) {
      return (data as List)
              .map((e) => deserialize<_iav2z4fb.DoseEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_ivovkn5g.TimelineItem>) {
      return (data as List)
              .map((e) => deserialize<_ivovkn5g.TimelineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_isnu78ia.PatientStatus>) {
      return (data as List)
              .map((e) => deserialize<_isnu78ia.PatientStatus>(e))
              .toList()
          as T;
    }
    if (t == List<_ii1trskb.Profile>) {
      return (data as List)
              .map((e) => deserialize<_ii1trskb.Profile>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iqmz6gj4.Alert => 'Alert',
      _iyp0oawi.AlertKind => 'AlertKind',
      _iyhbjbo5.AlertPriority => 'AlertPriority',
      _iq3u69l8.CareUpdate => 'CareUpdate',
      _ij0fpt9l.CheckInTurn => 'CheckInTurn',
      _i152b260.CheckStatus => 'CheckStatus',
      _i06tdmkm.CheckTrigger => 'CheckTrigger',
      _i6sqb1u1.DoseEvent => 'DoseEvent',
      _ihnxdm4b.DoseStatus => 'DoseStatus',
      _igwab1vy.Medication => 'Medication',
      _i32wz7ni.MedicationDraft => 'MedicationDraft',
      _iw8wpm46.PatientInsight => 'PatientInsight',
      _iibkifk1.PatientMemory => 'PatientMemory',
      _ik43n87i.PatientState => 'PatientState',
      _ifv8g6l9.PatientStatus => 'PatientStatus',
      _it6yrmua.Prescription => 'Prescription',
      _igud7pae.PrescriptionStatus => 'PrescriptionStatus',
      _ilz0o8l0.Profile => 'Profile',
      _i65v1yji.Role => 'Role',
      _i5cnrx2s.SymptomCount => 'SymptomCount',
      _i44gi5vp.SymptomReport => 'SymptomReport',
      _ignyleo4.TimelineItem => 'TimelineItem',
      _iez4s2vq.TimelineKind => 'TimelineKind',
      _iwziokxg.TimelineTone => 'TimelineTone',
      _in1yelte.UploadTicket => 'UploadTicket',
      _ita6sj68.WellnessCheck => 'WellnessCheck',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('dhatri.', '');
    }

    switch (data) {
      case _iqmz6gj4.Alert():
        return 'Alert';
      case _iyp0oawi.AlertKind():
        return 'AlertKind';
      case _iyhbjbo5.AlertPriority():
        return 'AlertPriority';
      case _iq3u69l8.CareUpdate():
        return 'CareUpdate';
      case _ij0fpt9l.CheckInTurn():
        return 'CheckInTurn';
      case _i152b260.CheckStatus():
        return 'CheckStatus';
      case _i06tdmkm.CheckTrigger():
        return 'CheckTrigger';
      case _i6sqb1u1.DoseEvent():
        return 'DoseEvent';
      case _ihnxdm4b.DoseStatus():
        return 'DoseStatus';
      case _igwab1vy.Medication():
        return 'Medication';
      case _i32wz7ni.MedicationDraft():
        return 'MedicationDraft';
      case _iw8wpm46.PatientInsight():
        return 'PatientInsight';
      case _iibkifk1.PatientMemory():
        return 'PatientMemory';
      case _ik43n87i.PatientState():
        return 'PatientState';
      case _ifv8g6l9.PatientStatus():
        return 'PatientStatus';
      case _it6yrmua.Prescription():
        return 'Prescription';
      case _igud7pae.PrescriptionStatus():
        return 'PrescriptionStatus';
      case _ilz0o8l0.Profile():
        return 'Profile';
      case _i65v1yji.Role():
        return 'Role';
      case _i5cnrx2s.SymptomCount():
        return 'SymptomCount';
      case _i44gi5vp.SymptomReport():
        return 'SymptomReport';
      case _ignyleo4.TimelineItem():
        return 'TimelineItem';
      case _iez4s2vq.TimelineKind():
        return 'TimelineKind';
      case _iwziokxg.TimelineTone():
        return 'TimelineTone';
      case _in1yelte.UploadTicket():
        return 'UploadTicket';
      case _ita6sj68.WellnessCheck():
        return 'WellnessCheck';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Alert') {
      return deserialize<_iqmz6gj4.Alert>(data['data']);
    }
    if (dataClassName == 'AlertKind') {
      return deserialize<_iyp0oawi.AlertKind>(data['data']);
    }
    if (dataClassName == 'AlertPriority') {
      return deserialize<_iyhbjbo5.AlertPriority>(data['data']);
    }
    if (dataClassName == 'CareUpdate') {
      return deserialize<_iq3u69l8.CareUpdate>(data['data']);
    }
    if (dataClassName == 'CheckInTurn') {
      return deserialize<_ij0fpt9l.CheckInTurn>(data['data']);
    }
    if (dataClassName == 'CheckStatus') {
      return deserialize<_i152b260.CheckStatus>(data['data']);
    }
    if (dataClassName == 'CheckTrigger') {
      return deserialize<_i06tdmkm.CheckTrigger>(data['data']);
    }
    if (dataClassName == 'DoseEvent') {
      return deserialize<_i6sqb1u1.DoseEvent>(data['data']);
    }
    if (dataClassName == 'DoseStatus') {
      return deserialize<_ihnxdm4b.DoseStatus>(data['data']);
    }
    if (dataClassName == 'Medication') {
      return deserialize<_igwab1vy.Medication>(data['data']);
    }
    if (dataClassName == 'MedicationDraft') {
      return deserialize<_i32wz7ni.MedicationDraft>(data['data']);
    }
    if (dataClassName == 'PatientInsight') {
      return deserialize<_iw8wpm46.PatientInsight>(data['data']);
    }
    if (dataClassName == 'PatientMemory') {
      return deserialize<_iibkifk1.PatientMemory>(data['data']);
    }
    if (dataClassName == 'PatientState') {
      return deserialize<_ik43n87i.PatientState>(data['data']);
    }
    if (dataClassName == 'PatientStatus') {
      return deserialize<_ifv8g6l9.PatientStatus>(data['data']);
    }
    if (dataClassName == 'Prescription') {
      return deserialize<_it6yrmua.Prescription>(data['data']);
    }
    if (dataClassName == 'PrescriptionStatus') {
      return deserialize<_igud7pae.PrescriptionStatus>(data['data']);
    }
    if (dataClassName == 'Profile') {
      return deserialize<_ilz0o8l0.Profile>(data['data']);
    }
    if (dataClassName == 'Role') {
      return deserialize<_i65v1yji.Role>(data['data']);
    }
    if (dataClassName == 'SymptomCount') {
      return deserialize<_i5cnrx2s.SymptomCount>(data['data']);
    }
    if (dataClassName == 'SymptomReport') {
      return deserialize<_i44gi5vp.SymptomReport>(data['data']);
    }
    if (dataClassName == 'TimelineItem') {
      return deserialize<_ignyleo4.TimelineItem>(data['data']);
    }
    if (dataClassName == 'TimelineKind') {
      return deserialize<_iez4s2vq.TimelineKind>(data['data']);
    }
    if (dataClassName == 'TimelineTone') {
      return deserialize<_iwziokxg.TimelineTone>(data['data']);
    }
    if (dataClassName == 'UploadTicket') {
      return deserialize<_in1yelte.UploadTicket>(data['data']);
    }
    if (dataClassName == 'WellnessCheck') {
      return deserialize<_ita6sj68.WellnessCheck>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('dhatri', this);
    _iacc.Protocol().registerHostProtocol('dhatri', this);
  }

  @override
  String getModuleName() => 'dhatri';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
