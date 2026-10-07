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
import 'dart:typed_data' as _idt;
import 'package:serverpod/serverpod.dart' as _is;

abstract class CheckInTurn
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CheckInTurn._({
    required this.checkId,
    required this.turnIndex,
    required this.text,
    required this.audio,
    required this.done,
  });

  factory CheckInTurn({
    required int checkId,
    required int turnIndex,
    required String text,
    required _idt.ByteData audio,
    required bool done,
  }) = _CheckInTurnImpl;

  factory CheckInTurn.fromJson(Map<String, dynamic> jsonSerialization) {
    return CheckInTurn(
      checkId: jsonSerialization['checkId'] as int,
      turnIndex: jsonSerialization['turnIndex'] as int,
      text: jsonSerialization['text'] as String,
      audio: _is.ByteDataJsonExtension.fromJson(jsonSerialization['audio']),
      done: _is.BoolJsonExtension.fromJson(jsonSerialization['done']),
    );
  }

  int checkId;

  int turnIndex;

  String text;

  _idt.ByteData audio;

  bool done;

  /// Returns a shallow copy of this [CheckInTurn]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CheckInTurn copyWith({
    int? checkId,
    int? turnIndex,
    String? text,
    _idt.ByteData? audio,
    bool? done,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CheckInTurn',
      'checkId': checkId,
      'turnIndex': turnIndex,
      'text': text,
      'audio': audio.toJson(),
      'done': done,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CheckInTurn',
      'checkId': checkId,
      'turnIndex': turnIndex,
      'text': text,
      'audio': audio.toJson(),
      'done': done,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _CheckInTurnImpl extends CheckInTurn {
  _CheckInTurnImpl({
    required int checkId,
    required int turnIndex,
    required String text,
    required _idt.ByteData audio,
    required bool done,
  }) : super._(
         checkId: checkId,
         turnIndex: turnIndex,
         text: text,
         audio: audio,
         done: done,
       );

  /// Returns a shallow copy of this [CheckInTurn]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CheckInTurn copyWith({
    int? checkId,
    int? turnIndex,
    String? text,
    _idt.ByteData? audio,
    bool? done,
  }) {
    return CheckInTurn(
      checkId: checkId ?? this.checkId,
      turnIndex: turnIndex ?? this.turnIndex,
      text: text ?? this.text,
      audio: audio ?? this.audio.clone(),
      done: done ?? this.done,
    );
  }
}
