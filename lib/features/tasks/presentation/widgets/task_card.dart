import 'package:duha_app/common/utils/priority_colors.dart';
import 'package:duha_app/features/tasks/data/models/task_model.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const TaskCard({
    required this.task,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final priorityColor = getPriorityColor(task.priority);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) => onToggle(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        if (task.description.isNotEmpty)
                          Text(
                            task.description,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: priorityColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      task.priority.name.toUpperCase(),
                      style: TextStyle(
                        color: priorityColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // Multi-assignee progress
              if (task.assigneeIds.length > 1) ...[
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.people, size: 16, color: Colors.blue[700]),
                          SizedBox(width: 6),
                          Text(
                            'Team Task - ${task.completedByIds.length}/${task.assigneeIds.length} completed',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: task.completionProgress,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Subtasks progress
              if (task.subtasks.isNotEmpty) ...[
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 14, color: Colors.grey),
                    SizedBox(width: 6),
                    Text(
                      '${task.completedSubtasksCount}/${task.subtasks.length} subtasks',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],

              // Bottom info
              SizedBox(height: 8),
              Row(
                children: [
                  if (task.deadline != null) ...[
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      '${task.deadline!.day}/${task.deadline!.month}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    SizedBox(width: 12),
                  ],
                  if (task.repeat != null) ...[
                    Icon(Icons.repeat, size: 14, color: Colors.purple),
                    SizedBox(width: 4),
                    Text(
                      task.repeat!,
                      style: TextStyle(fontSize: 12, color: Colors.purple),
                    ),
                    SizedBox(width: 12),
                  ],
                  Icon(Icons.star, size: 14, color: Colors.amber),
                  SizedBox(width: 4),
                  Text(
                    '${task.xpReward} XP',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  if (task.comments.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.comment, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('${task.comments.length}',
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  if (task.attachments.isNotEmpty) ...[
                    SizedBox(width: 12),
                    Icon(Icons.attach_file, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('${task.attachments.length}',
                        style: TextStyle(fontSize: 12)),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}