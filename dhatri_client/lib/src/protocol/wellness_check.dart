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
import 'check_status.dart' as _i152b260;
import 'check_trigger.dart' as _i06tdmkm;

abstract class WellnessCheck
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  WellnessCheck._({
    this.id,
    required this.patientId,
    required this.status,
    required this.trigger,
    int? turnCount,
    this.transcript,
    this.replyText,
    this.mood,
    this.summaryEn,
    this.memoryUsed,
    DateTime? createdAt,
    this.completedAt,
  }) : turnCount = turnCount ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory WellnessCheck({
    int? id,
    required int patientId,
    required _i152b260.CheckStatus status,
    required _i06tdmkm.CheckTrigger trigger,
    int? turnCount,
    String? transcript,
    String? replyText,
    String? mood,
    String? summaryEn,
    List<String>? memoryUsed,
    DateTime? createdAt,
    DateTime? completedAt,
  }) = _WellnessCheckImpl;

  factory WellnessCheck.fromJson(Map<String, dynamic> jsonSerialization) {
    return WellnessCheck(
      id: jsonSerialization['id'] as int?,
      patientId: jsonSerialization['patientId'] as int,
      status: _i152b260.CheckStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      trigger: _i06tdmkm.CheckTrigger.fromJson(
        (jsonSerialization['trigger'] as String),
      ),
      turnCount: jsonSerialization['turnCount'] as int?,
      transcript: jsonSerialization['transcript'] as String?,
      replyText: jsonSerialization['replyText'] as String?,
      mood: jsonSerialization['mood'] as String?,
      summaryEn: jsonSerialization['summaryEn'] as String?,
      memoryUsed: jsonSerialization['memoryUsed'] == null
          ? null
          : _i3jg2yd6.Protocol().deserialize<List<String>>(
              jsonSerialization['memoryUsed'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int patientId;

  _i152b260.CheckStatus status;

  _i06tdmkm.CheckTrigger trigger;

  int turnCount;

  String? transcript;

  String? replyText;

  String? mood;

  String? summaryEn;

  List<String>? memoryUsed;

  DateTime createdAt;

  DateTime? completedAt;

  /// Returns a shallow copy of this [WellnessCheck]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  WellnessCheck copyWith({
    int? id,
    int? patientId,
    _i152b260.CheckStatus? status,
    _i06tdmkm.CheckTrigger? trigger,
    int? turnCount,
    String? transcript,
    String? replyText,
    String? mood,
    String? summaryEn,
    List<String>? memoryUsed,
    DateTime? createdAt,
    DateTime? completedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WellnessCheck',
      if (id != null) 'id': id,
      'patientId': patientId,
      'status': status.toJson(),
      'trigger': trigger.toJson(),
      'turnCount': turnCount,
      if (transcript != null) 'transcript': transcript,
      if (replyText != null) 'replyText': replyText,
      if (mood != null) 'mood': mood,
      if (summaryEn != null) 'summaryEn': summaryEn,
      if (memoryUsed != null) 'memoryUsed': memoryUsed?.toJson(),
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WellnessCheck',
      if (id != null) 'id': id,
      'patientId': patientId,
      'status': status.toJson(),
      'trigger': trigger.toJson(),
      'turnCount': turnCount,
      if (transcript != null) 'transcript': transcript,
      if (replyText != null) 'replyText': replyText,
      if (mood != null) 'mood': mood,
      if (summaryEn != null) 'summaryEn': summaryEn,
      if (memoryUsed != null) 'memoryUsed': memoryUsed?.toJson(),
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WellnessCheckImpl extends WellnessCheck {
  _WellnessCheckImpl({
    int? id,
    required int patientId,
    required _i152b260.CheckStatus status,
    required _i06tdmkm.CheckTrigger trigger,
    int? turnCount,
    String? transcript,
    String? replyText,
    String? mood,
    String? summaryEn,
    List<String>? memoryUsed,
    DateTime? createdAt,
    DateTime? completedAt,
  }) : super._(
         id: id,
         patientId: patientId,
         status: status,
         trigger: trigger,
         turnCount: turnCount,
         transcript: transcript,
         replyText: replyText,
         mood: mood,
         summaryEn: summaryEn,
         memoryUsed: memoryUsed,
         createdAt: createdAt,
         completedAt: completedAt,
       );

  /// Returns a shallow copy of this [WellnessCheck]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  WellnessCheck copyWith({
    Object? id = _Undefined,
    int? patientId,
    _i152b260.CheckStatus? status,
    _i06tdmkm.CheckTrigger? trigger,
    int? turnCount,
    Object? transcript = _Undefined,
    Object? replyText = _Undefined,
    Object? mood = _Undefined,
    Object? summaryEn = _Undefined,
    Object? memoryUsed = _Undefined,
    DateTime? createdAt,
    Object? completedAt = _Undefined,
  }) {
    return WellnessCheck(
      id: id is int? ? id : this.id,
      patientId: patientId ?? this.patientId,
      status: status ?? this.status,
      trigger: trigger ?? this.trigger,
      turnCount: turnCount ?? this.turnCount,
      transcript: transcript is String? ? transcript : this.transcript,
      replyText: replyText is String? ? replyText : this.replyText,
      mood: mood is String? ? mood : this.mood,
      summaryEn: summaryEn is String? ? summaryEn : this.summaryEn,
      memoryUsed: memoryUsed is List<String>?
          ? memoryUsed
          : this.memoryUsed?.map((e0) => e0).toList(),
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
    );
  }
}
