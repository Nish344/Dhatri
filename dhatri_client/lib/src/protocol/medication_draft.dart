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

abstract class MedicationDraft
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MedicationDraft._({
    required this.name,
    this.strength,
    required this.doseText,
    this.instructions,
    required this.times,
    required this.durationDays,
    required this.uncertain,
  });

  factory MedicationDraft({
    required String name,
    String? strength,
    required String doseText,
    String? instructions,
    required List<String> times,
    required int durationDays,
    required bool uncertain,
  }) = _MedicationDraftImpl;

  factory MedicationDraft.fromJson(Map<String, dynamic> jsonSerialization) {
    return MedicationDraft(
      name: jsonSerialization['name'] as String,
      strength: jsonSerialization['strength'] as String?,
      doseText: jsonSerialization['doseText'] as String,
      instructions: jsonSerialization['instructions'] as String?,
      times: _i3jg2yd6.Protocol().deserialize<List<String>>(
        jsonSerialization['times'],
      ),
      durationDays: jsonSerialization['durationDays'] as int,
      uncertain: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['uncertain'],
      ),
    );
  }

  String name;

  String? strength;

  String doseText;

  String? instructions;

  List<String> times;

  int durationDays;

  bool uncertain;

  /// Returns a shallow copy of this [MedicationDraft]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MedicationDraft copyWith({
    String? name,
    String? strength,
    String? doseText,
    String? instructions,
    List<String>? times,
    int? durationDays,
    bool? uncertain,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MedicationDraft',
      'name': name,
      if (strength != null) 'strength': strength,
      'doseText': doseText,
      if (instructions != null) 'instructions': instructions,
      'times': times.toJson(),
      'durationDays': durationDays,
      'uncertain': uncertain,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MedicationDraft',
      'name': name,
      if (strength != null) 'strength': strength,
      'doseText': doseText,
      if (instructions != null) 'instructions': instructions,
      'times': times.toJson(),
      'durationDays': durationDays,
      'uncertain': uncertain,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MedicationDraftImpl extends MedicationDraft {
  _MedicationDraftImpl({
    required String name,
    String? strength,
    required String doseText,
    String? instructions,
    required List<String> times,
    required int durationDays,
    required bool uncertain,
  }) : super._(
         name: name,
         strength: strength,
         doseText: doseText,
         instructions: instructions,
         times: times,
         durationDays: durationDays,
         uncertain: uncertain,
       );

  /// Returns a shallow copy of this [MedicationDraft]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MedicationDraft copyWith({
    String? name,
    Object? strength = _Undefined,
    String? doseText,
    Object? instructions = _Undefined,
    List<String>? times,
    int? durationDays,
    bool? uncertain,
  }) {
    return MedicationDraft(
      name: name ?? this.name,
      strength: strength is String? ? strength : this.strength,
      doseText: doseText ?? this.doseText,
      instructions: instructions is String? ? instructions : this.instructions,
      times: times ?? this.times.map((e0) => e0).toList(),
      durationDays: durationDays ?? this.durationDays,
      uncertain: uncertain ?? this.uncertain,
    );
  }
}
