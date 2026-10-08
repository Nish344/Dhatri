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
import 'package:dhatri_server/src/generated/check_trigger.dart' as _i2nd0i1y;
import 'package:serverpod/serverpod.dart' as _is;

abstract class CheckInFutureCallOpenModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CheckInFutureCallOpenModel._({
    required this.patientId,
    required this.trigger,
  });

  factory CheckInFutureCallOpenModel({
    required int patientId,
    required _i2nd0i1y.CheckTrigger trigger,
  }) = _CheckInFutureCallOpenModelImpl;

  factory CheckInFutureCallOpenModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CheckInFutureCallOpenModel(
      patientId: jsonSerialization['patientId'] as int,
      trigger: _i2nd0i1y.CheckTrigger.fromJson(
        (jsonSerialization['trigger'] as String),
      ),
    );
  }

  int patientId;

  _i2nd0i1y.CheckTrigger trigger;

  /// Returns a shallow copy of this [CheckInFutureCallOpenModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CheckInFutureCallOpenModel copyWith({
    int? patientId,
    _i2nd0i1y.CheckTrigger? trigger,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CheckInFutureCallOpenModel',
      'patientId': patientId,
      'trigger': trigger.toJson(),
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

class _CheckInFutureCallOpenModelImpl extends CheckInFutureCallOpenModel {
  _CheckInFutureCallOpenModelImpl({
    required int patientId,
    required _i2nd0i1y.CheckTrigger trigger,
  }) : super._(
         patientId: patientId,
         trigger: trigger,
       );

  /// Returns a shallow copy of this [CheckInFutureCallOpenModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CheckInFutureCallOpenModel copyWith({
    int? patientId,
    _i2nd0i1y.CheckTrigger? trigger,
  }) {
    return CheckInFutureCallOpenModel(
      patientId: patientId ?? this.patientId,
      trigger: trigger ?? this.trigger,
    );
  }
}
