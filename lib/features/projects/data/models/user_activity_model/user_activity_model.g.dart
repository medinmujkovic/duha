// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserActivityImpl _$$UserActivityImplFromJson(Map<String, dynamic> json) =>
    _$UserActivityImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      groupId: json['groupId'] as String,
      userId: json['userId'] as String,
      xp: json['xp'] as String,
      level: json['level'] as String,
      streak: json['streak'] as String,
    );

Map<String, dynamic> _$$UserActivityImplToJson(_$UserActivityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'groupId': instance.groupId,
      'userId': instance.userId,
      'xp': instance.xp,
      'level': instance.level,
      'streak': instance.streak,
    };
