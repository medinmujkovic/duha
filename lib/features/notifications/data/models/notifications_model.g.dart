// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationsImpl _$$NotificationsImplFromJson(Map<String, dynamic> json) =>
    _$NotificationsImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      content: json['content'] as String,
      groupId: json['groupId'] as String?,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      viewed: json['viewed'] as bool,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$NotificationsImplToJson(_$NotificationsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'content': instance.content,
      'groupId': instance.groupId,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'viewed': instance.viewed,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.groupInvite: 'groupInvite',
  NotificationType.friendsUpdate: 'friendsUpdate',
};
