import 'package:duha_app/common/utils/priority_colors.dart';
import 'package:duha_app/features/tasks/data/enums/task_enum.dart';
import 'package:duha_app/features/tasks/data/models/task/task_model.dart';
import 'package:flutter/material.dart';

class GroupTaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const GroupTaskCard({
    super.key,
    required this.task,
    required this.onTap,
  });


  String _getDueDateText(DateTime? dueAt) {
    if (dueAt == null) return 'Bez roka';
    final now = DateTime.now();
    final difference = dueAt.difference(now);

    if (difference.isNegative) {
      return 'Kasni ${difference.inDays.abs()} dana';
    } else if (difference.inDays == 0) {
      return 'Danas';
    } else if (difference.inDays == 1) {
      return 'Sutra';
    } else {
      return 'Za ${difference.inDays} dana';
    }
  }

  double _getProgress() {
    if (task.subtasks.isEmpty) {
      return task.completedByIds.isNotEmpty ? 1.0 : 0.0;
    }

    final completed = task.subtasks.where((s) => s.isCompleted).length;
    return completed / task.subtasks.length;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _getProgress();
    final hasSubtasks = task.subtasks.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title + Priority
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: getPriorityColor(task.priority).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.priority.name,
                      style: TextStyle(
                        color: getPriorityColor(task.priority),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              ...[
              const SizedBox(height: 8),
              Text(
                task.description,
                style: const TextStyle(color: Color.fromARGB(255, 68, 25, 25)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

              const SizedBox(height: 12),

              // Progress bar (ako ima subtaskova)
              if (hasSubtasks) ...[
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progress == 1.0 ? Colors.green : Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${task.subtasks.where((s) => s.isCompleted).length}/${task.subtasks.length} podzadataka',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
              ],

              // Footer: Assignees + Due date + Type
              Row(
                children: [
                  // Assignees avatars
                  if (task.assigneeIds.isNotEmpty)
                    SizedBox(
                      width: 80,
                      height: 28,
                      child: Stack(
                        children: List.generate(
                          task.assigneeIds.length > 3
                              ? 3
                              : task.assigneeIds.length,
                          (index) => Positioned(
                            left: index * 20.0,
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors
                                  .primaries[index % Colors.primaries.length],
                              child: Text(
                                'U${index + 1}',
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(width: 12),

                  // Due date
                  const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    _getDueDateText(task.deadline),
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),

                  const Spacer(),

                  // Task type chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: task.type == TaskType.allMembers
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.type == TaskType.allMembers ? 'SVI' : 'BILO KO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: task.type == TaskType.allMembers
                            ? Colors.blue
                            : Colors.purple,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}