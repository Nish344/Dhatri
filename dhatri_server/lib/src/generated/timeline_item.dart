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
import 'timeline_kind.dart' as _iez4s2vq;
import 'timeline_tone.dart' as _iwziokxg;

abstract class TimelineItem
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TimelineItem._({
    required this.at,
    required this.kind,
    required this.tone,
    required this.title,
    this.detail,
  });

  factory TimelineItem({
    required DateTime at,
    required _iez4s2vq.TimelineKind kind,
    required _iwziokxg.TimelineTone tone,
    required String title,
    String? detail,
  }) = _TimelineItemImpl;

  factory TimelineItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return TimelineItem(
      at: _is.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
      kind: _iez4s2vq.TimelineKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      tone: _iwziokxg.TimelineTone.fromJson(
        (jsonSerialization['tone'] as String),
      ),
      title: jsonSerialization['title'] as String,
      detail: jsonSerialization['detail'] as String?,
    );
  }

  DateTime at;

  _iez4s2vq.TimelineKind kind;

  _iwziokxg.TimelineTone tone;

  String title;

  String? detail;

  /// Returns a shallow copy of this [TimelineItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TimelineItem copyWith({
    DateTime? at,
    _iez4s2vq.TimelineKind? kind,
    _iwziokxg.TimelineTone? tone,
    String? title,
    String? detail,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TimelineItem',
      'at': at.toJson(),
      'kind': kind.toJson(),
      'tone': tone.toJson(),
      'title': title,
      if (detail != null) 'detail': detail,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TimelineItem',
      'at': at.toJson(),
      'kind': kind.toJson(),
      'tone': tone.toJson(),
      'title': title,
      if (detail != null) 'detail': detail,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TimelineItemImpl extends TimelineItem {
  _TimelineItemImpl({
    required DateTime at,
    required _iez4s2vq.TimelineKind kind,
    required _iwziokxg.TimelineTone tone,
    required String title,
    String? detail,
  }) : super._(
         at: at,
         kind: kind,
         tone: tone,
         title: title,
         detail: detail,
       );

  /// Returns a shallow copy of this [TimelineItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TimelineItem copyWith({
    DateTime? at,
    _iez4s2vq.TimelineKind? kind,
    _iwziokxg.TimelineTone? tone,
    String? title,
    Object? detail = _Undefined,
  }) {
    return TimelineItem(
      at: at ?? this.at,
      kind: kind ?? this.kind,
      tone: tone ?? this.tone,
      title: title ?? this.title,
      detail: detail is String? ? detail : this.detail,
    );
  }
}
