import 'package:duha_app/core/util/task_utils.dart';
import 'package:duha_app/features/auth/presentation/providers/user_provider.dart';
import 'package:duha_app/features/tasks/data/datasources/data_service.dart';
import 'package:duha_app/features/tasks/data/models/task_enum.dart';
import 'package:duha_app/features/tasks/data/models/subtask/subtask_model.dart';
import 'package:duha_app/features/tasks/data/models/task_comment.dart';
import 'package:duha_app/features/tasks/data/models/taskattachment_model.dart';
import 'package:duha_app/features/tasks/data/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  final DataService _dataService = DataService();
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final user = ref.read(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showTaskDetail(context,_dataService, task);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Header
            Container(
              padding: const EdgeInsets.all(20),
              color: _getPriorityColor(task.priority).withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) {
                          setState(() {
                            _dataService.toggleTaskCompletion(
                                task.id,user?.id ?? '');
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (task.description.isNotEmpty)
                    Text(
                      task.description,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                ],
              ),
            ),

            // Task Info Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                      Icons.flag, 'Priority', task.priority.name.toUpperCase()),
                  if (task.deadline != null)
                    _buildInfoRow(Icons.calendar_today, 'Due Date',
                        '${task.deadline!.day}/${task.deadline!.month}/${task.deadline!.year}'),
                  if (task.repeat != null)
                    _buildInfoRow(Icons.repeat, 'Repeats', task.repeat!),
                  _buildInfoRow(Icons.star, 'XP Reward', '${task.xpReward}'),
                ],
              ),
            ),

            const Divider(),

            // Assignees Section
            if (task.assigneeIds.length > 1) ...[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Team Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: task.completionProgress,
                              backgroundColor: Colors.grey[300],
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(Colors.blue),
                              minHeight: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${task.completedByIds.length} of ${task.assigneeIds.length} members completed',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...task.assigneeIds.map((assigneeId) {
                            final isCompleted =
                                task.completedByIds.contains(assigneeId);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: isCompleted
                                        ? Colors.green
                                        : Colors.grey[300],
                                    child: Icon(
                                      isCompleted ? Icons.check : Icons.person,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      assigneeId,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  if (isCompleted)
                                    const Icon(Icons.check_circle,
                                        color: Colors.green),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
            ],

            // Subtasks Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtasks (${task.completedSubtasksCount}/${task.subtasks.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _showAddSubtaskDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...task.subtasks.map((subtask) => CheckboxListTile(
                        value: subtask.isCompleted,
                        onChanged: (value) {
                          setState(() {
                            subtask = subtask.copyWith(isCompleted: !value!);
                          });
                        },
                        title: Text(
                          subtask.title,
                          style: TextStyle(
                            decoration: subtask.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      )),
                ],
              ),
            ),

            const Divider(),

            // Attachments Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Attachments',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _showAddAttachmentDialog(context),
                        icon: const Icon(Icons.attach_file),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (task.attachments.isEmpty)
                    const Center(
                      child: Text(
                        'No attachments yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    ...task.attachments.map((attachment) => Card(
                          child: ListTile(
                            leading: Icon(
                              attachment.type == 'image'
                                  ? Icons.image
                                  : Icons.description,
                              color: const Color(0xFF7C3AED),
                            ),
                            title: Text(attachment.name),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  task.attachments.remove(attachment);
                                });
                              },
                            ),
                          ),
                        )),
                ],
              ),
            ),

            const Divider(),

            // Comments Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...task.comments.map((comment) => Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: const Color(0xFF7C3AED),
                                    child: Text(
                                      comment.userName[0].toUpperCase(),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment.userName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${comment.timestamp.day}/${comment.timestamp.month} ${comment.timestamp.hour}:${comment.timestamp.minute}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(comment.content),
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          maxLines: null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send),
                        color: const Color(0xFF7C3AED),
                        onPressed: () {
                          if (_commentController.text.isNotEmpty) {
                            setState(() {
                              task.comments.add(TaskComment(
                                id: DateTime.now().toString(),
                                userId: user?.id ?? '',
                                userName: user?.name ?? 'Unknown',
                                content: _commentController.text,
                                timestamp: DateTime.now(),
                              ));
                              _commentController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.urgent:
        return Colors.red;
      case Priority.high:
        return Colors.orange;
      case Priority.medium:
        return Colors.yellow[700]!;
      case Priority.low:
        return Colors.green;
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _dataService.deleteTask(widget.task.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddSubtaskDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Subtask'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Subtask title'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  widget.task.subtasks.add(Subtask(
                    id: DateTime.now().toString(),
                    title: controller.text,
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddAttachmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Attachment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Image'),
              onTap: () {
                setState(() {
                  widget.task.attachments.add(TaskAttachment(
                    id: DateTime.now().toString(),
                    name: 'Image_${DateTime.now().millisecondsSinceEpoch}.jpg',
                    type: 'image',
                    url: 'mock_url',
                  ));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Document'),
              onTap: () {
                setState(() {
                  widget.task.attachments.add(TaskAttachment(
                    id: DateTime.now().toString(),
                    name:
                        'Document_${DateTime.now().millisecondsSinceEpoch}.pdf',
                    type: 'document',
                    url: 'mock_url',
                  ));
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
