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

abstract class PrescriptionFutureCallExtractModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PrescriptionFutureCallExtractModel._({required this.prescriptionId});

  factory PrescriptionFutureCallExtractModel({required int prescriptionId}) =
      _PrescriptionFutureCallExtractModelImpl;

  factory PrescriptionFutureCallExtractModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PrescriptionFutureCallExtractModel(
      prescriptionId: jsonSerialization['prescriptionId'] as int,
    );
  }

  int prescriptionId;

  /// Returns a shallow copy of this [PrescriptionFutureCallExtractModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PrescriptionFutureCallExtractModel copyWith({int? prescriptionId});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PrescriptionFutureCallExtractModel',
      'prescriptionId': prescriptionId,
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

class _PrescriptionFutureCallExtractModelImpl
    extends PrescriptionFutureCallExtractModel {
  _PrescriptionFutureCallExtractModelImpl({required int prescriptionId})
    : super._(prescriptionId: prescriptionId);

  /// Returns a shallow copy of this [PrescriptionFutureCallExtractModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PrescriptionFutureCallExtractModel copyWith({int? prescriptionId}) {
    return PrescriptionFutureCallExtractModel(
      prescriptionId: prescriptionId ?? this.prescriptionId,
    );
  }
}
