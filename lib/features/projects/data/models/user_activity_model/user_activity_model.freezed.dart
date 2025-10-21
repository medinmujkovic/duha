// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_activity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserActivity _$UserActivityFromJson(Map<String, dynamic> json) {
  return _UserActivity.fromJson(json);
}

/// @nodoc
mixin _$UserActivity {
  String get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get groupId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get xp => throw _privateConstructorUsedError;
  String get level => throw _privateConstructorUsedError;
  String get streak => throw _privateConstructorUsedError;

  /// Serializes this UserActivity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserActivityCopyWith<UserActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserActivityCopyWith<$Res> {
  factory $UserActivityCopyWith(
          UserActivity value, $Res Function(UserActivity) then) =
      _$UserActivityCopyWithImpl<$Res, UserActivity>;
  @useResult
  $Res call(
      {String id,
      String username,
      String groupId,
      String userId,
      String xp,
      String level,
      String streak});
}

/// @nodoc
class _$UserActivityCopyWithImpl<$Res, $Val extends UserActivity>
    implements $UserActivityCopyWith<$Res> {
  _$UserActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? groupId = null,
    Object? userId = null,
    Object? xp = null,
    Object? level = null,
    Object? streak = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      xp: null == xp
          ? _value.xp
          : xp // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserActivityImplCopyWith<$Res>
    implements $UserActivityCopyWith<$Res> {
  factory _$$UserActivityImplCopyWith(
          _$UserActivityImpl value, $Res Function(_$UserActivityImpl) then) =
      __$$UserActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String username,
      String groupId,
      String userId,
      String xp,
      String level,
      String streak});
}

/// @nodoc
class __$$UserActivityImplCopyWithImpl<$Res>
    extends _$UserActivityCopyWithImpl<$Res, _$UserActivityImpl>
    implements _$$UserActivityImplCopyWith<$Res> {
  __$$UserActivityImplCopyWithImpl(
      _$UserActivityImpl _value, $Res Function(_$UserActivityImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? groupId = null,
    Object? userId = null,
    Object? xp = null,
    Object? level = null,
    Object? streak = null,
  }) {
    return _then(_$UserActivityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      xp: null == xp
          ? _value.xp
          : xp // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserActivityImpl implements _UserActivity {
  const _$UserActivityImpl(
      {required this.id,
      required this.username,
      required this.groupId,
      required this.userId,
      required this.xp,
      required this.level,
      required this.streak});

  factory _$UserActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserActivityImplFromJson(json);

  @override
  final String id;
  @override
  final String username;
  @override
  final String groupId;
  @override
  final String userId;
  @override
  final String xp;
  @override
  final String level;
  @override
  final String streak;

  @override
  String toString() {
    return 'UserActivity(id: $id, username: $username, groupId: $groupId, userId: $userId, xp: $xp, level: $level, streak: $streak)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserActivityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.xp, xp) || other.xp == xp) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.streak, streak) || other.streak == streak));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, username, groupId, userId, xp, level, streak);

  /// Create a copy of UserActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserActivityImplCopyWith<_$UserActivityImpl> get copyWith =>
      __$$UserActivityImplCopyWithImpl<_$UserActivityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserActivityImplToJson(
      this,
    );
  }
}

abstract class _UserActivity implements UserActivity {
  const factory _UserActivity(
      {required final String id,
      required final String username,
      required final String groupId,
      required final String userId,
      required final String xp,
      required final String level,
      required final String streak}) = _$UserActivityImpl;

  factory _UserActivity.fromJson(Map<String, dynamic> json) =
      _$UserActivityImpl.fromJson;

  @override
  String get id;
  @override
  String get username;
  @override
  String get groupId;
  @override
  String get userId;
  @override
  String get xp;
  @override
  String get level;
  @override
  String get streak;

  /// Create a copy of UserActivity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserActivityImplCopyWith<_$UserActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
