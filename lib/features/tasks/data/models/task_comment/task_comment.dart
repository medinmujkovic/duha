import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_comment.freezed.dart';
part 'task_comment.g.dart';

@freezed
class TaskComment with _$TaskComment {
  const factory TaskComment({
    required String id,
    required String userId,
    required String userName,
    required String content,
    required DateTime timestamp,
  }) = _TaskComment;

  factory TaskComment.fromJson(Map<String, dynamic> json) =>
      _$TaskCommentFromJson(json);
}
