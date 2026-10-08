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

abstract class CheckInFutureCallRingModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CheckInFutureCallRingModel._({required this.checkId});

  factory CheckInFutureCallRingModel({required int checkId}) =
      _CheckInFutureCallRingModelImpl;

  factory CheckInFutureCallRingModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CheckInFutureCallRingModel(
      checkId: jsonSerialization['checkId'] as int,
    );
  }

  int checkId;

  /// Returns a shallow copy of this [CheckInFutureCallRingModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CheckInFutureCallRingModel copyWith({int? checkId});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CheckInFutureCallRingModel',
      'checkId': checkId,
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

class _CheckInFutureCallRingModelImpl extends CheckInFutureCallRingModel {
  _CheckInFutureCallRingModelImpl({required int checkId})
    : super._(checkId: checkId);

  /// Returns a shallow copy of this [CheckInFutureCallRingModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CheckInFutureCallRingModel copyWith({int? checkId}) {
    return CheckInFutureCallRingModel(checkId: checkId ?? this.checkId);
  }
}
