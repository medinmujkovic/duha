
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_activity_model.freezed.dart';
part 'user_activity_model.g.dart';


@freezed
class UserActivity with _$UserActivity {
  const factory UserActivity({
    required String id,
    required String username,
    required String groupId,
    required String userId,
    required String xp,
    required String level,
    required String streak,
  }) = _UserActivity;

  factory UserActivity.fromJson(Map<String, dynamic> json) => _$UserActivityFromJson(json);

}
