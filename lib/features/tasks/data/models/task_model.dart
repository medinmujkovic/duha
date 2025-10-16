import 'package:duha_app/features/tasks/data/models/task_enum.dart';
import 'package:duha_app/features/tasks/data/models/subtask_model.dart';
import 'package:duha_app/features/tasks/data/models/task_comment.dart';
import 'package:duha_app/features/tasks/data/models/taskattachment_model.dart';

class Task {
  final String id;
  String title;
  String description;
  Priority priority;
  DateTime? deadline;
  TaskType? type; // all-members, specific-members
  String? repeat; // 'daily', 'weekly', 'monthly', 'every-2-days', 'weekdays'
  String? groupId;
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

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = Priority.medium,
    this.deadline,
    this.repeat,
    required this.groupId,
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
    this.type,
  });

  bool get isCompleted => assigneeIds.isNotEmpty && 
      assigneeIds.every((id) => completedByIds.contains(id));

  double get completionProgress => 
      assigneeIds.isEmpty ? 0.0 : completedByIds.length / assigneeIds.length;

  int get completedSubtasksCount => 
      subtasks.where((st) => st.isCompleted).length;
}
