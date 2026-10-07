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
import 'package:serverpod/serverpod.dart' as _is;

abstract class SymptomCount
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SymptomCount._({
    required this.symptom,
    required this.count,
    required this.maxSeverity,
  });

  factory SymptomCount({
    required String symptom,
    required int count,
    required int maxSeverity,
  }) = _SymptomCountImpl;

  factory SymptomCount.fromJson(Map<String, dynamic> jsonSerialization) {
    return SymptomCount(
      symptom: jsonSerialization['symptom'] as String,
      count: jsonSerialization['count'] as int,
      maxSeverity: jsonSerialization['maxSeverity'] as int,
    );
  }

  String symptom;

  int count;

  int maxSeverity;

  /// Returns a shallow copy of this [SymptomCount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SymptomCount copyWith({
    String? symptom,
    int? count,
    int? maxSeverity,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SymptomCount',
      'symptom': symptom,
      'count': count,
      'maxSeverity': maxSeverity,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SymptomCount',
      'symptom': symptom,
      'count': count,
      'maxSeverity': maxSeverity,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SymptomCountImpl extends SymptomCount {
  _SymptomCountImpl({
    required String symptom,
    required int count,
    required int maxSeverity,
  }) : super._(
         symptom: symptom,
         count: count,
         maxSeverity: maxSeverity,
       );

  /// Returns a shallow copy of this [SymptomCount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SymptomCount copyWith({
    String? symptom,
    int? count,
    int? maxSeverity,
  }) {
    return SymptomCount(
      symptom: symptom ?? this.symptom,
      count: count ?? this.count,
      maxSeverity: maxSeverity ?? this.maxSeverity,
    );
  }
}
