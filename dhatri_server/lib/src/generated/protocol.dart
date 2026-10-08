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
import 'package:dhatri_server/src/generated/dose_event.dart' as _iz3f95dj;
import 'package:dhatri_server/src/generated/medication.dart' as _iaybl2va;
import 'package:dhatri_server/src/generated/medication_draft.dart' as _i5ggnd2q;
import 'package:dhatri_server/src/generated/patient_status.dart' as _i14rvz8t;
import 'package:dhatri_server/src/generated/profile.dart' as _i87t4uqf;
import 'package:dhatri_server/src/generated/timeline_item.dart' as _i2fss586;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'alert.dart' as _iqmz6gj4;
import 'alert_kind.dart' as _iyp0oawi;
import 'alert_priority.dart' as _iyhbjbo5;
import 'care_update.dart' as _iq3u69l8;
import 'check_in_turn.dart' as _ij0fpt9l;
import 'check_status.dart' as _i152b260;
import 'check_trigger.dart' as _i06tdmkm;
import 'dose_event.dart' as _i6sqb1u1;
import 'dose_status.dart' as _ihnxdm4b;
import 'future_calls_generated_models/check_in_future_call_open_model.dart'
    as _ie10p2ff;
import 'future_calls_generated_models/check_in_future_call_ring_model.dart'
    as _ik839svv;
import 'future_calls_generated_models/dose_future_call_escalate_model.dart'
    as _iegx9ko2;
import 'future_calls_generated_models/dose_future_call_remind_model.dart'
    as _irhelafm;
import 'future_calls_generated_models/prescription_future_call_extract_model.dart'
    as _ivzuxvpb;
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

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'alert',
      dartName: 'Alert',
      schema: 'public',
      module: 'dhatri',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'patientId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AlertKind',
        ),
        _isp.ColumnDefinition(
          name: 'priority',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AlertPriority',
        ),
        _isp.ColumnDefinition(
          name: 'doseEventId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'symptom',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'message',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'acknowledgedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'alert_open_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'patientId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'acknowledgedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'dose_event',
      dartName: 'DoseEvent',
      schema: 'public',
      module: 'dhatri',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'patientId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'medicationId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'scheduledAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:DoseStatus',
        ),
        _isp.ColumnDefinition(
          name: 'remindedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'takenAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'dose_once_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'medicationId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'scheduledAt',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'dose_patient_time_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'patientId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'scheduledAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'medication',
      dartName: 'Medication',
      schema: 'public',
      module: 'dhatri',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'patientId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'prescriptionId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'strength',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'doseText',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'instructions',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'times',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'startDate',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'endDate',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'active',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'patient_memory',
      dartName: 'PatientMemory',
      schema: 'public',
      module: 'dhatri',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'patientId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'content',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'sourceCheckId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'embedding',
          columnType: _isp.ColumnType.vector,
          isNullable: false,
          dartType: 'Vector(768)',
          vectorDimension: 768,
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'memory_patient_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'patientId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'memory_embedding_hnsw_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'embedding',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.cosine,
          vectorColumnType: _isp.ColumnType.vector,
          parameters: {
            'm': '16',
            'ef_construction': '64',
          },
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'prescription',
      dartName: 'Prescription',
      schema: 'public',
      module: 'dhatri',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'patientId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'storageId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'path',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:PrescriptionStatus',
        ),
        _isp.ColumnDefinition(
          name: 'extractedJson',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'error',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'profile',
      dartName: 'Profile',
      schema: 'public',
      module: 'dhatri',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:Role',
        ),
        _isp.ColumnDefinition(
          name: 'age',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'phone',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'caregiverId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'doctorId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'linkCode',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'profile_auth_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'profile_link_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'linkCode',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'symptom_report',
      dartName: 'SymptomReport',
      schema: 'public',
      module: 'dhatri',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'patientId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'checkId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'symptom',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'severity',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'reportedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'symptom_lookup_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'patientId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'symptom',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'reportedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'wellness_check',
      dartName: 'WellnessCheck',
      schema: 'public',
      module: 'dhatri',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'patientId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:CheckStatus',
        ),
        _isp.ColumnDefinition(
          name: 'trigger',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:CheckTrigger',
        ),
        _isp.ColumnDefinition(
          name: 'turnCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'ringCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'snoozeCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'transcript',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'replyText',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'mood',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'summaryEn',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'memoryUsed',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<String>?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'completedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

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
      } on _is.DeserializationClassNameNotFoundException catch (_) {
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
    if (t == _ie10p2ff.CheckInFutureCallOpenModel) {
      return _ie10p2ff.CheckInFutureCallOpenModel.fromJson(data) as T;
    }
    if (t == _ik839svv.CheckInFutureCallRingModel) {
      return _ik839svv.CheckInFutureCallRingModel.fromJson(data) as T;
    }
    if (t == _iegx9ko2.DoseFutureCallEscalateModel) {
      return _iegx9ko2.DoseFutureCallEscalateModel.fromJson(data) as T;
    }
    if (t == _irhelafm.DoseFutureCallRemindModel) {
      return _irhelafm.DoseFutureCallRemindModel.fromJson(data) as T;
    }
    if (t == _ivzuxvpb.PrescriptionFutureCallExtractModel) {
      return _ivzuxvpb.PrescriptionFutureCallExtractModel.fromJson(data) as T;
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
    if (t == _is.getType<_iqmz6gj4.Alert?>()) {
      return (data != null ? _iqmz6gj4.Alert.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iyp0oawi.AlertKind?>()) {
      return (data != null ? _iyp0oawi.AlertKind.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iyhbjbo5.AlertPriority?>()) {
      return (data != null ? _iyhbjbo5.AlertPriority.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iq3u69l8.CareUpdate?>()) {
      return (data != null ? _iq3u69l8.CareUpdate.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ij0fpt9l.CheckInTurn?>()) {
      return (data != null ? _ij0fpt9l.CheckInTurn.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i152b260.CheckStatus?>()) {
      return (data != null ? _i152b260.CheckStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i06tdmkm.CheckTrigger?>()) {
      return (data != null ? _i06tdmkm.CheckTrigger.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i6sqb1u1.DoseEvent?>()) {
      return (data != null ? _i6sqb1u1.DoseEvent.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ihnxdm4b.DoseStatus?>()) {
      return (data != null ? _ihnxdm4b.DoseStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ie10p2ff.CheckInFutureCallOpenModel?>()) {
      return (data != null
              ? _ie10p2ff.CheckInFutureCallOpenModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ik839svv.CheckInFutureCallRingModel?>()) {
      return (data != null
              ? _ik839svv.CheckInFutureCallRingModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iegx9ko2.DoseFutureCallEscalateModel?>()) {
      return (data != null
              ? _iegx9ko2.DoseFutureCallEscalateModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_irhelafm.DoseFutureCallRemindModel?>()) {
      return (data != null
              ? _irhelafm.DoseFutureCallRemindModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ivzuxvpb.PrescriptionFutureCallExtractModel?>()) {
      return (data != null
              ? _ivzuxvpb.PrescriptionFutureCallExtractModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_igwab1vy.Medication?>()) {
      return (data != null ? _igwab1vy.Medication.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i32wz7ni.MedicationDraft?>()) {
      return (data != null ? _i32wz7ni.MedicationDraft.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iw8wpm46.PatientInsight?>()) {
      return (data != null ? _iw8wpm46.PatientInsight.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iibkifk1.PatientMemory?>()) {
      return (data != null ? _iibkifk1.PatientMemory.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ik43n87i.PatientState?>()) {
      return (data != null ? _ik43n87i.PatientState.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ifv8g6l9.PatientStatus?>()) {
      return (data != null ? _ifv8g6l9.PatientStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_it6yrmua.Prescription?>()) {
      return (data != null ? _it6yrmua.Prescription.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_igud7pae.PrescriptionStatus?>()) {
      return (data != null ? _igud7pae.PrescriptionStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ilz0o8l0.Profile?>()) {
      return (data != null ? _ilz0o8l0.Profile.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i65v1yji.Role?>()) {
      return (data != null ? _i65v1yji.Role.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i5cnrx2s.SymptomCount?>()) {
      return (data != null ? _i5cnrx2s.SymptomCount.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i44gi5vp.SymptomReport?>()) {
      return (data != null ? _i44gi5vp.SymptomReport.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ignyleo4.TimelineItem?>()) {
      return (data != null ? _ignyleo4.TimelineItem.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iez4s2vq.TimelineKind?>()) {
      return (data != null ? _iez4s2vq.TimelineKind.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iwziokxg.TimelineTone?>()) {
      return (data != null ? _iwziokxg.TimelineTone.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_in1yelte.UploadTicket?>()) {
      return (data != null ? _in1yelte.UploadTicket.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ita6sj68.WellnessCheck?>()) {
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
    if (t == _is.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_iz3f95dj.DoseEvent>) {
      return (data as List)
              .map((e) => deserialize<_iz3f95dj.DoseEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_i2fss586.TimelineItem>) {
      return (data as List)
              .map((e) => deserialize<_i2fss586.TimelineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i14rvz8t.PatientStatus>) {
      return (data as List)
              .map((e) => deserialize<_i14rvz8t.PatientStatus>(e))
              .toList()
          as T;
    }
    if (t == List<_i5ggnd2q.MedicationDraft>) {
      return (data as List)
              .map((e) => deserialize<_i5ggnd2q.MedicationDraft>(e))
              .toList()
          as T;
    }
    if (t == List<_iaybl2va.Medication>) {
      return (data as List)
              .map((e) => deserialize<_iaybl2va.Medication>(e))
              .toList()
          as T;
    }
    if (t == List<_i87t4uqf.Profile>) {
      return (data as List)
              .map((e) => deserialize<_i87t4uqf.Profile>(e))
              .toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
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
      _ie10p2ff.CheckInFutureCallOpenModel => 'CheckInFutureCallOpenModel',
      _ik839svv.CheckInFutureCallRingModel => 'CheckInFutureCallRingModel',
      _iegx9ko2.DoseFutureCallEscalateModel => 'DoseFutureCallEscalateModel',
      _irhelafm.DoseFutureCallRemindModel => 'DoseFutureCallRemindModel',
      _ivzuxvpb.PrescriptionFutureCallExtractModel =>
        'PrescriptionFutureCallExtractModel',
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
      case _ie10p2ff.CheckInFutureCallOpenModel():
        return 'CheckInFutureCallOpenModel';
      case _ik839svv.CheckInFutureCallRingModel():
        return 'CheckInFutureCallRingModel';
      case _iegx9ko2.DoseFutureCallEscalateModel():
        return 'DoseFutureCallEscalateModel';
      case _irhelafm.DoseFutureCallRemindModel():
        return 'DoseFutureCallRemindModel';
      case _ivzuxvpb.PrescriptionFutureCallExtractModel():
        return 'PrescriptionFutureCallExtractModel';
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
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
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
    if (dataClassName == 'CheckInFutureCallOpenModel') {
      return deserialize<_ie10p2ff.CheckInFutureCallOpenModel>(data['data']);
    }
    if (dataClassName == 'CheckInFutureCallRingModel') {
      return deserialize<_ik839svv.CheckInFutureCallRingModel>(data['data']);
    }
    if (dataClassName == 'DoseFutureCallEscalateModel') {
      return deserialize<_iegx9ko2.DoseFutureCallEscalateModel>(data['data']);
    }
    if (dataClassName == 'DoseFutureCallRemindModel') {
      return deserialize<_irhelafm.DoseFutureCallRemindModel>(data['data']);
    }
    if (dataClassName == 'PrescriptionFutureCallExtractModel') {
      return deserialize<_ivzuxvpb.PrescriptionFutureCallExtractModel>(
        data['data'],
      );
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
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('dhatri', this);
    _iacs.Protocol().registerHostProtocol('dhatri', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _iqmz6gj4.Alert:
        return _iqmz6gj4.Alert.t;
      case _i6sqb1u1.DoseEvent:
        return _i6sqb1u1.DoseEvent.t;
      case _igwab1vy.Medication:
        return _igwab1vy.Medication.t;
      case _iibkifk1.PatientMemory:
        return _iibkifk1.PatientMemory.t;
      case _it6yrmua.Prescription:
        return _it6yrmua.Prescription.t;
      case _ilz0o8l0.Profile:
        return _ilz0o8l0.Profile.t;
      case _i44gi5vp.SymptomReport:
        return _i44gi5vp.SymptomReport.t;
      case _ita6sj68.WellnessCheck:
        return _ita6sj68.WellnessCheck.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

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
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
