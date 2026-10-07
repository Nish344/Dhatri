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

abstract class DoseFutureCallRemindModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DoseFutureCallRemindModel._({required this.doseEventId});

  factory DoseFutureCallRemindModel({required int doseEventId}) =
      _DoseFutureCallRemindModelImpl;

  factory DoseFutureCallRemindModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DoseFutureCallRemindModel(
      doseEventId: jsonSerialization['doseEventId'] as int,
    );
  }

  int doseEventId;

  /// Returns a shallow copy of this [DoseFutureCallRemindModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DoseFutureCallRemindModel copyWith({int? doseEventId});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoseFutureCallRemindModel',
      'doseEventId': doseEventId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _DoseFutureCallRemindModelImpl extends DoseFutureCallRemindModel {
  _DoseFutureCallRemindModelImpl({required int doseEventId})
    : super._(doseEventId: doseEventId);

  /// Returns a shallow copy of this [DoseFutureCallRemindModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DoseFutureCallRemindModel copyWith({int? doseEventId}) {
    return DoseFutureCallRemindModel(
      doseEventId: doseEventId ?? this.doseEventId,
    );
  }
}
