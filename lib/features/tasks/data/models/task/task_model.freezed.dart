// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Task _$TaskFromJson(Map<String, dynamic> json) {
  return _Task.fromJson(json);
}

/// @nodoc
mixin _$Task {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  Priority get priority => throw _privateConstructorUsedError;
  DateTime? get deadline => throw _privateConstructorUsedError;
  TaskType? get type =>
      throw _privateConstructorUsedError; // all-members, specific-members
  String? get repeat =>
      throw _privateConstructorUsedError; // 'daily', 'weekly', 'monthly', 'every-2-days', 'weekdays'
  String? get groupId => throw _privateConstructorUsedError;
  List<String> get assigneeIds => throw _privateConstructorUsedError;
  List<String> get completedByIds => throw _privateConstructorUsedError;
  List<Subtask> get subtasks => throw _privateConstructorUsedError;
  List<TaskComment> get comments => throw _privateConstructorUsedError;
  List<TaskAttachment> get attachments => throw _privateConstructorUsedError;
  String? get sectionId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  int get xpReward => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res, Task>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      Priority priority,
      DateTime? deadline,
      TaskType? type,
      String? repeat,
      String? groupId,
      List<String> assigneeIds,
      List<String> completedByIds,
      List<Subtask> subtasks,
      List<TaskComment> comments,
      List<TaskAttachment> attachments,
      String? sectionId,
      DateTime createdAt,
      DateTime? completedAt,
      int xpReward,
      List<String> tags});
}

/// @nodoc
class _$TaskCopyWithImpl<$Res, $Val extends Task>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? priority = null,
    Object? deadline = freezed,
    Object? type = freezed,
    Object? repeat = freezed,
    Object? groupId = freezed,
    Object? assigneeIds = null,
    Object? completedByIds = null,
    Object? subtasks = null,
    Object? comments = null,
    Object? attachments = null,
    Object? sectionId = freezed,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? xpReward = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as Priority,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TaskType?,
      repeat: freezed == repeat
          ? _value.repeat
          : repeat // ignore: cast_nullable_to_non_nullable
              as String?,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      assigneeIds: null == assigneeIds
          ? _value.assigneeIds
          : assigneeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      completedByIds: null == completedByIds
          ? _value.completedByIds
          : completedByIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      subtasks: null == subtasks
          ? _value.subtasks
          : subtasks // ignore: cast_nullable_to_non_nullable
              as List<Subtask>,
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<TaskComment>,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<TaskAttachment>,
      sectionId: freezed == sectionId
          ? _value.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      xpReward: null == xpReward
          ? _value.xpReward
          : xpReward // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
          _$TaskImpl value, $Res Function(_$TaskImpl) then) =
      __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      Priority priority,
      DateTime? deadline,
      TaskType? type,
      String? repeat,
      String? groupId,
      List<String> assigneeIds,
      List<String> completedByIds,
      List<Subtask> subtasks,
      List<TaskComment> comments,
      List<TaskAttachment> attachments,
      String? sectionId,
      DateTime createdAt,
      DateTime? completedAt,
      int xpReward,
      List<String> tags});
}

/// @nodoc
class __$$TaskImplCopyWithImpl<$Res>
    extends _$TaskCopyWithImpl<$Res, _$TaskImpl>
    implements _$$TaskImplCopyWith<$Res> {
  __$$TaskImplCopyWithImpl(_$TaskImpl _value, $Res Function(_$TaskImpl) _then)
      : super(_value, _then);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? priority = null,
    Object? deadline = freezed,
    Object? type = freezed,
    Object? repeat = freezed,
    Object? groupId = freezed,
    Object? assigneeIds = null,
    Object? completedByIds = null,
    Object? subtasks = null,
    Object? comments = null,
    Object? attachments = null,
    Object? sectionId = freezed,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? xpReward = null,
    Object? tags = null,
  }) {
    return _then(_$TaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as Priority,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TaskType?,
      repeat: freezed == repeat
          ? _value.repeat
          : repeat // ignore: cast_nullable_to_non_nullable
              as String?,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      assigneeIds: null == assigneeIds
          ? _value._assigneeIds
          : assigneeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      completedByIds: null == completedByIds
          ? _value._completedByIds
          : completedByIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      subtasks: null == subtasks
          ? _value._subtasks
          : subtasks // ignore: cast_nullable_to_non_nullable
              as List<Subtask>,
      comments: null == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<TaskComment>,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<TaskAttachment>,
      sectionId: freezed == sectionId
          ? _value.sectionId
          : sectionId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      xpReward: null == xpReward
          ? _value.xpReward
          : xpReward // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskImpl extends _Task {
  const _$TaskImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.priority,
      required this.deadline,
      required this.type,
      required this.repeat,
      required this.groupId,
      final List<String> assigneeIds = const [],
      final List<String> completedByIds = const [],
      final List<Subtask> subtasks = const [],
      final List<TaskComment> comments = const [],
      final List<TaskAttachment> attachments = const [],
      this.sectionId,
      required this.createdAt,
      this.completedAt,
      this.xpReward = 0,
      final List<String> tags = const []})
      : _assigneeIds = assigneeIds,
        _completedByIds = completedByIds,
        _subtasks = subtasks,
        _comments = comments,
        _attachments = attachments,
        _tags = tags,
        super._();

  factory _$TaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final Priority priority;
  @override
  final DateTime? deadline;
  @override
  final TaskType? type;
// all-members, specific-members
  @override
  final String? repeat;
// 'daily', 'weekly', 'monthly', 'every-2-days', 'weekdays'
  @override
  final String? groupId;
  final List<String> _assigneeIds;
  @override
  @JsonKey()
  List<String> get assigneeIds {
    if (_assigneeIds is EqualUnmodifiableListView) return _assigneeIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assigneeIds);
  }

  final List<String> _completedByIds;
  @override
  @JsonKey()
  List<String> get completedByIds {
    if (_completedByIds is EqualUnmodifiableListView) return _completedByIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedByIds);
  }

  final List<Subtask> _subtasks;
  @override
  @JsonKey()
  List<Subtask> get subtasks {
    if (_subtasks is EqualUnmodifiableListView) return _subtasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subtasks);
  }

  final List<TaskComment> _comments;
  @override
  @JsonKey()
  List<TaskComment> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  final List<TaskAttachment> _attachments;
  @override
  @JsonKey()
  List<TaskAttachment> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  final String? sectionId;
  @override
  final DateTime createdAt;
  @override
  final DateTime? completedAt;
  @override
  @JsonKey()
  final int xpReward;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, priority: $priority, deadline: $deadline, type: $type, repeat: $repeat, groupId: $groupId, assigneeIds: $assigneeIds, completedByIds: $completedByIds, subtasks: $subtasks, comments: $comments, attachments: $attachments, sectionId: $sectionId, createdAt: $createdAt, completedAt: $completedAt, xpReward: $xpReward, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.repeat, repeat) || other.repeat == repeat) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            const DeepCollectionEquality()
                .equals(other._assigneeIds, _assigneeIds) &&
            const DeepCollectionEquality()
                .equals(other._completedByIds, _completedByIds) &&
            const DeepCollectionEquality().equals(other._subtasks, _subtasks) &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.sectionId, sectionId) ||
                other.sectionId == sectionId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.xpReward, xpReward) ||
                other.xpReward == xpReward) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      priority,
      deadline,
      type,
      repeat,
      groupId,
      const DeepCollectionEquality().hash(_assigneeIds),
      const DeepCollectionEquality().hash(_completedByIds),
      const DeepCollectionEquality().hash(_subtasks),
      const DeepCollectionEquality().hash(_comments),
      const DeepCollectionEquality().hash(_attachments),
      sectionId,
      createdAt,
      completedAt,
      xpReward,
      const DeepCollectionEquality().hash(_tags));

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImplToJson(
      this,
    );
  }
}

abstract class _Task extends Task {
  const factory _Task(
      {required final String id,
      required final String title,
      required final String description,
      required final Priority priority,
      required final DateTime? deadline,
      required final TaskType? type,
      required final String? repeat,
      required final String? groupId,
      final List<String> assigneeIds,
      final List<String> completedByIds,
      final List<Subtask> subtasks,
      final List<TaskComment> comments,
      final List<TaskAttachment> attachments,
      final String? sectionId,
      required final DateTime createdAt,
      final DateTime? completedAt,
      final int xpReward,
      final List<String> tags}) = _$TaskImpl;
  const _Task._() : super._();

  factory _Task.fromJson(Map<String, dynamic> json) = _$TaskImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  Priority get priority;
  @override
  DateTime? get deadline;
  @override
  TaskType? get type; // all-members, specific-members
  @override
  String?
      get repeat; // 'daily', 'weekly', 'monthly', 'every-2-days', 'weekdays'
  @override
  String? get groupId;
  @override
  List<String> get assigneeIds;
  @override
  List<String> get completedByIds;
  @override
  List<Subtask> get subtasks;
  @override
  List<TaskComment> get comments;
  @override
  List<TaskAttachment> get attachments;
  @override
  String? get sectionId;
  @override
  DateTime get createdAt;
  @override
  DateTime? get completedAt;
  @override
  int get xpReward;
  @override
  List<String> get tags;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
