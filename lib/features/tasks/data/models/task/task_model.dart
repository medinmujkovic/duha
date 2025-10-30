import 'package:duha_app/features/tasks/data/enums/task_enum.dart';
import 'package:duha_app/features/tasks/data/models/subtask/subtask_model.dart';
import 'package:duha_app/features/tasks/data/models/task_comment/task_comment.dart';
import 'package:duha_app/features/tasks/data/models/task_attachment/task_attachment.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class Task with _$Task {

  const Task._();

  const factory Task({
  required String id,
  required String title,
  required String description,
  required Priority priority,
  required DateTime? deadline,
  required TaskType? type, // all-members, specific-members
  required String? repeat, // 'daily', 'weekly', 'monthly', 'every-2-days', 'weekdays'
  required String? groupId,
  @Default([]) List<String> assigneeIds,
  @Default([]) List<String> completedByIds,
  @Default([]) List<Subtask> subtasks,
  @Default([]) List<TaskComment> comments,
  @Default([]) List<TaskAttachment> attachments,
  String? sectionId,
  required DateTime createdAt,
  DateTime? completedAt,
  @Default(0) int xpReward,
  @Default([]) List<String> tags,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

    bool get isCompleted =>
      assigneeIds.isNotEmpty && assigneeIds.every(completedByIds.contains);

  double get completionProgress =>
      assigneeIds.isEmpty ? 0.0 : completedByIds.length / assigneeIds.length;

  int get completedSubtasksCount =>
      subtasks.where((st) => st.isCompleted).length;

}
