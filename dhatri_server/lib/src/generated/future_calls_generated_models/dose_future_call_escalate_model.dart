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

abstract class DoseFutureCallEscalateModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DoseFutureCallEscalateModel._({required this.doseEventId});

  factory DoseFutureCallEscalateModel({required int doseEventId}) =
      _DoseFutureCallEscalateModelImpl;

  factory DoseFutureCallEscalateModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DoseFutureCallEscalateModel(
      doseEventId: jsonSerialization['doseEventId'] as int,
    );
  }

  int doseEventId;

  /// Returns a shallow copy of this [DoseFutureCallEscalateModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DoseFutureCallEscalateModel copyWith({int? doseEventId});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoseFutureCallEscalateModel',
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

class _DoseFutureCallEscalateModelImpl extends DoseFutureCallEscalateModel {
  _DoseFutureCallEscalateModelImpl({required int doseEventId})
    : super._(doseEventId: doseEventId);

  /// Returns a shallow copy of this [DoseFutureCallEscalateModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DoseFutureCallEscalateModel copyWith({int? doseEventId}) {
    return DoseFutureCallEscalateModel(
      doseEventId: doseEventId ?? this.doseEventId,
    );
  }
}
