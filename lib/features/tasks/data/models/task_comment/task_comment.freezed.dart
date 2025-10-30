// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskComment _$TaskCommentFromJson(Map<String, dynamic> json) {
  return _TaskComment.fromJson(json);
}

/// @nodoc
mixin _$TaskComment {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this TaskComment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCommentCopyWith<TaskComment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCommentCopyWith<$Res> {
  factory $TaskCommentCopyWith(
          TaskComment value, $Res Function(TaskComment) then) =
      _$TaskCommentCopyWithImpl<$Res, TaskComment>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String content,
      DateTime timestamp});
}

/// @nodoc
class _$TaskCommentCopyWithImpl<$Res, $Val extends TaskComment>
    implements $TaskCommentCopyWith<$Res> {
  _$TaskCommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? content = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskCommentImplCopyWith<$Res>
    implements $TaskCommentCopyWith<$Res> {
  factory _$$TaskCommentImplCopyWith(
          _$TaskCommentImpl value, $Res Function(_$TaskCommentImpl) then) =
      __$$TaskCommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String content,
      DateTime timestamp});
}

/// @nodoc
class __$$TaskCommentImplCopyWithImpl<$Res>
    extends _$TaskCommentCopyWithImpl<$Res, _$TaskCommentImpl>
    implements _$$TaskCommentImplCopyWith<$Res> {
  __$$TaskCommentImplCopyWithImpl(
      _$TaskCommentImpl _value, $Res Function(_$TaskCommentImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? content = null,
    Object? timestamp = null,
  }) {
    return _then(_$TaskCommentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskCommentImpl implements _TaskComment {
  const _$TaskCommentImpl(
      {required this.id,
      required this.userId,
      required this.userName,
      required this.content,
      required this.timestamp});

  factory _$TaskCommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskCommentImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String content;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'TaskComment(id: $id, userId: $userId, userName: $userName, content: $content, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskCommentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, userName, content, timestamp);

  /// Create a copy of TaskComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskCommentImplCopyWith<_$TaskCommentImpl> get copyWith =>
      __$$TaskCommentImplCopyWithImpl<_$TaskCommentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskCommentImplToJson(
      this,
    );
  }
}

abstract class _TaskComment implements TaskComment {
  const factory _TaskComment(
      {required final String id,
      required final String userId,
      required final String userName,
      required final String content,
      required final DateTime timestamp}) = _$TaskCommentImpl;

  factory _TaskComment.fromJson(Map<String, dynamic> json) =
      _$TaskCommentImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String get content;
  @override
  DateTime get timestamp;

  /// Create a copy of TaskComment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskCommentImplCopyWith<_$TaskCommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
