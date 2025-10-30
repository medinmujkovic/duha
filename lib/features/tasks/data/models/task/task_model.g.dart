// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: $enumDecode(_$PriorityEnumMap, json['priority']),
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      type: $enumDecodeNullable(_$TaskTypeEnumMap, json['type']),
      repeat: json['repeat'] as String?,
      groupId: json['groupId'] as String?,
      assigneeIds: (json['assigneeIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      completedByIds: (json['completedByIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      subtasks: (json['subtasks'] as List<dynamic>?)
              ?.map((e) => Subtask.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => TaskComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => TaskAttachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      sectionId: json['sectionId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'priority': _$PriorityEnumMap[instance.priority]!,
      'deadline': instance.deadline?.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'repeat': instance.repeat,
      'groupId': instance.groupId,
      'assigneeIds': instance.assigneeIds,
      'completedByIds': instance.completedByIds,
      'subtasks': instance.subtasks,
      'comments': instance.comments,
      'attachments': instance.attachments,
      'sectionId': instance.sectionId,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'xpReward': instance.xpReward,
      'tags': instance.tags,
    };

const _$PriorityEnumMap = {
  Priority.low: 'low',
  Priority.medium: 'medium',
  Priority.high: 'high',
  Priority.urgent: 'urgent',
};

const _$TaskTypeEnumMap = {
  TaskType.allMembers: 'allMembers',
  TaskType.specificMembers: 'specificMembers',
};
