// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TokenImpl _$$TokenImplFromJson(Map<String, dynamic> json) => _$TokenImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      token: json['token'] as String,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$TokenImplToJson(_$TokenImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'token': instance.token,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
