

import 'package:duha_app/features/todos/data/models/priority_model.dart';
import 'package:duha_app/features/todos/data/models/subtask_model.dart';
import 'package:duha_app/features/todos/data/models/task_comment.dart';
import 'package:duha_app/features/todos/data/models/taskattachment_model.dart';

class TodoTask {
  final String id;
  String title;
  String description;
  Priority priority;
  DateTime? deadline;
  String? repeat; // 'daily', 'weekly', 'monthly', 'every-2-days', 'weekdays'
  String projectId;
  List<String> assigneeIds;
  List<String> completedByIds;
  List<Subtask> subtasks;
  List<TaskComment> comments;
  List<TaskAttachment> attachments;
  String? sectionId;
  DateTime createdAt;
  DateTime? completedAt;
  int xpReward;
  List<String> tags;

  TodoTask({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = Priority.medium,
    this.deadline,
    this.repeat,
    required this.projectId,
    required this.assigneeIds,
    this.completedByIds = const [],
    this.subtasks = const [],
    this.comments = const [],
    this.attachments = const [],
    this.sectionId,
    required this.createdAt,
    this.completedAt,
    this.xpReward = 50,
    this.tags = const [],
  });

  bool get isCompleted => assigneeIds.isNotEmpty && 
      assigneeIds.every((id) => completedByIds.contains(id));

  double get completionProgress => 
      assigneeIds.isEmpty ? 0.0 : completedByIds.length / assigneeIds.length;

  int get completedSubtasksCount => 
      subtasks.where((st) => st.isCompleted).length;
}
