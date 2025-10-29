import 'package:duha_app/core/util/json_converter.dart';
import 'package:duha_app/features/notifications/data/models/notification_enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications_model.freezed.dart';
part 'notifications_model.g.dart';

@freezed
class Notifications with _$Notifications {
  const factory Notifications({
    required String id,
    required String userId,
    required String name,
    required String content,
    required String? groupId, 
    required NotificationType type,
    required bool viewed,
    @TimestampConverter() required DateTime createdAt,
  }) = _Notifications;

  factory Notifications.fromJson(Map<String, dynamic> json) => _$NotificationsFromJson(json);
}
