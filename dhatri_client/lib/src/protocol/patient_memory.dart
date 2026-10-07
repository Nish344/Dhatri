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

abstract class PatientMemory
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PatientMemory._({
    this.id,
    required this.patientId,
    required this.kind,
    required this.content,
    this.sourceCheckId,
    DateTime? createdAt,
    required this.embedding,
  }) : createdAt = createdAt ?? DateTime.now();

  factory PatientMemory({
    int? id,
    required int patientId,
    required String kind,
    required String content,
    int? sourceCheckId,
    DateTime? createdAt,
    required _isc.Vector embedding,
  }) = _PatientMemoryImpl;

  factory PatientMemory.fromJson(Map<String, dynamic> jsonSerialization) {
    return PatientMemory(
      id: jsonSerialization['id'] as int?,
      patientId: jsonSerialization['patientId'] as int,
      kind: jsonSerialization['kind'] as String,
      content: jsonSerialization['content'] as String,
      sourceCheckId: jsonSerialization['sourceCheckId'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      embedding: _isc.VectorJsonExtension.fromJson(
        jsonSerialization['embedding'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int patientId;

  String kind;

  String content;

  int? sourceCheckId;

  DateTime createdAt;

  _isc.Vector embedding;

  /// Returns a shallow copy of this [PatientMemory]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PatientMemory copyWith({
    int? id,
    int? patientId,
    String? kind,
    String? content,
    int? sourceCheckId,
    DateTime? createdAt,
    _isc.Vector? embedding,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PatientMemory',
      if (id != null) 'id': id,
      'patientId': patientId,
      'kind': kind,
      'content': content,
      if (sourceCheckId != null) 'sourceCheckId': sourceCheckId,
      'createdAt': createdAt.toJson(),
      'embedding': embedding.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PatientMemory',
      if (id != null) 'id': id,
      'patientId': patientId,
      'kind': kind,
      'content': content,
      if (sourceCheckId != null) 'sourceCheckId': sourceCheckId,
      'createdAt': createdAt.toJson(),
      'embedding': embedding.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PatientMemoryImpl extends PatientMemory {
  _PatientMemoryImpl({
    int? id,
    required int patientId,
    required String kind,
    required String content,
    int? sourceCheckId,
    DateTime? createdAt,
    required _isc.Vector embedding,
  }) : super._(
         id: id,
         patientId: patientId,
         kind: kind,
         content: content,
         sourceCheckId: sourceCheckId,
         createdAt: createdAt,
         embedding: embedding,
       );

  /// Returns a shallow copy of this [PatientMemory]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PatientMemory copyWith({
    Object? id = _Undefined,
    int? patientId,
    String? kind,
    String? content,
    Object? sourceCheckId = _Undefined,
    DateTime? createdAt,
    _isc.Vector? embedding,
  }) {
    return PatientMemory(
      id: id is int? ? id : this.id,
      patientId: patientId ?? this.patientId,
      kind: kind ?? this.kind,
      content: content ?? this.content,
      sourceCheckId: sourceCheckId is int? ? sourceCheckId : this.sourceCheckId,
      createdAt: createdAt ?? this.createdAt,
      embedding: embedding ?? this.embedding.clone(),
    );
  }
}
