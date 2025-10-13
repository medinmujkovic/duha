// lib/presentation/group/group_detail_screen.dart
import 'package:duha_app/common/widgets/new_task_button.dart';
import 'package:duha_app/features/tasks/data/models/task_enum.dart';
import 'package:duha_app/features/tasks/data/models/subtask_model.dart';
import 'package:duha_app/features/tasks/data/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupDetailScreen extends ConsumerStatefulWidget {
  final String groupId;

  const GroupDetailScreen({
    super.key,
    required this.groupId,
  });

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen> {
  // Mock data za testiranje
  final List<Task> _mockTasks = [
    Task(
      id: '1',
      groupId: 'group1',
      title: 'Dizajnirati novi logo',
      description: 'Kreirati moderan logo za aplikaciju',
      type: TaskType.specificMembers,
      assigneeIds: ['user1', 'user2'],
      subtasks: [
        Subtask(id: '1', title: 'Istraživanje konkurencije', isCompleted: true),
        Subtask(id: '2', title: 'Skice i draft verzije', isCompleted: true),
        Subtask(id: '3', title: 'Finalna verzija', isCompleted: false),
      ],
      deadline: DateTime.now().add(Duration(days: 3)),
      priority: Priority.high,
      completedByIds: ['user1'],
      createdAt: DateTime.now().subtract(Duration(days: 2)),
    ),
    Task(
      id: '2',
      groupId: 'group1',
      title: 'Dizajnirati novi logo',
      description: 'Kreirati moderan logo za aplikaciju',
      type: TaskType.specificMembers,
      assigneeIds: ['user1', 'user2'],
      subtasks: [
        Subtask(id: '1', title: 'Istraživanje konkurencije', isCompleted: true),
        Subtask(id: '2', title: 'Skice i draft verzije', isCompleted: true),
        Subtask(id: '3', title: 'Finalna verzija', isCompleted: false),
      ],
      deadline: DateTime.now().add(Duration(days: 3)),
      priority: Priority.high,
      completedByIds: ['user1'],
      createdAt: DateTime.now().subtract(Duration(days: 2)),
    ),
  ];

  bool _notificationsEnabled = true;

  void _showGroupMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.person_add, color: Colors.blue),
              title: Text('Dodaj člana'),
              onTap: () {
                Navigator.pop(context);
                _showAddMemberDialog();
              },
            ),
            ListTile(
              leading: Icon(
                _notificationsEnabled
                    ? Icons.notifications_off
                    : Icons.notifications_active,
                color: Colors.orange,
              ),
              title: Text(
                _notificationsEnabled
                    ? 'Isključi notifikacije'
                    : 'Uključi notifikacije',
              ),
              onTap: () {
                setState(() {
                  _notificationsEnabled = !_notificationsEnabled;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _notificationsEnabled
                          ? 'Notifikacije uključene'
                          : 'Notifikacije isključene',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.grey),
              title: Text('Postavke grupe'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementirati postavke
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Napusti grupu', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showLeaveGroupDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMemberDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Dodaj člana'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email adresa',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Otkaži'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Pozivnica poslana na ${emailController.text}')),
              );
            },
            child: Text('Pošalji pozivnicu'),
          ),
        ],
      ),
    );
  }

  void _showLeaveGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Napusti grupu?'),
        content: Text('Da li ste sigurni da želite napustiti ovu grupu?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Otkaži'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Vrati se na prethodni screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Napustili ste grupu')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Napusti'),
          ),
        ],
      ),
    );
  }

  void _showCreateTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateTaskDialog(groupId: widget.groupId),
    );
  }

  void _showTaskDetail(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => TaskDetailSheet(
          task: task,
          scrollController: scrollController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marketing Tim'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: _showGroupMenu,
          ),
        ],
      ),
      body: _mockTasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nema zadataka',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Kreirajte prvi zadatak za grupu',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _mockTasks.length,
              itemBuilder: (context, index) {
                final task = _mockTasks[index];
                return TaskCard(
                  task: task,
                  onTap: () => _showTaskDetail(task),
                );
              },
            ),
      floatingActionButton: AddTaskButton(
        onPressed: () {
          _showCreateTaskDialog();
        },
      ),
    );
  }
}

// Task Card Widget
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
  });

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
      case Priority.urgent:
        return Colors.purple;
    }
  }

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
      margin: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title + Priority
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(task.priority).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.priority.name,
                      style: TextStyle(
                        color: _getPriorityColor(task.priority),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              if (task.description != null) ...[
                SizedBox(height: 8),
                Text(
                  task.description!,
                  style: TextStyle(color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              SizedBox(height: 12),

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
                    SizedBox(width: 8),
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
                SizedBox(height: 8),
                Text(
                  '${task.subtasks.where((s) => s.isCompleted).length}/${task.subtasks.length} podzadataka',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                SizedBox(height: 12),
              ],

              // Footer: Assignees + Due date + Type
              Row(
                children: [
                  // Assignees avatars
                  if (task.assigneeIds != null && task.assigneeIds!.isNotEmpty)
                    SizedBox(
                      width: 80,
                      height: 28,
                      child: Stack(
                        children: List.generate(
                          task.assigneeIds!.length > 3
                              ? 3
                              : task.assigneeIds!.length,
                          (index) => Positioned(
                            left: index * 20.0,
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors
                                  .primaries[index % Colors.primaries.length],
                              child: Text(
                                'U${index + 1}',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  SizedBox(width: 12),

                  // Due date
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    _getDueDateText(task.deadline),
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),

                  Spacer(),

                  // Task type chip
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

// Task Detail Sheet
class TaskDetailSheet extends StatefulWidget {
  final Task task;
  final ScrollController scrollController;

  const TaskDetailSheet({
    super.key,
    required this.task,
    required this.scrollController,
  });

  @override
  State<TaskDetailSheet> createState() => _TaskDetailSheetState();
}

class _TaskDetailSheetState extends State<TaskDetailSheet> {
  late List<Subtask> _subtasks;

  @override
  void initState() {
    super.initState();
    _subtasks = List.from(widget.task.subtasks);
  }

  void _toggleSubtask(int index) {
    setState(() {
      _subtasks[index] =
          _subtasks[index].copyWith(isCompleted: !_subtasks[index].isCompleted);
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _subtasks.where((s) => s.isCompleted).length;
    final progress =
        _subtasks.isEmpty ? 0.0 : completedCount / _subtasks.length;

    return Container(
      padding: EdgeInsets.all(24),
      child: ListView(
        controller: widget.scrollController,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 24),

          // Title
          Text(
            widget.task.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          // Description
          if (widget.task.description != null) ...[
            Text(
              widget.task.description!,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 24),
          ],

          // Progress (if has subtasks)
          if (_subtasks.isNotEmpty) ...[
            Text(
              'Progres',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress == 1.0 ? Colors.green : Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '$completedCount/${_subtasks.length} podzadataka završeno (${(progress * 100).toInt()}%)',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 24),

            // Subtasks list
            Text(
              'Podzadaci',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ..._subtasks.asMap().entries.map((entry) {
              final index = entry.key;
              final subtask = entry.value;
              return CheckboxListTile(
                value: subtask.isCompleted,
                onChanged: (_) => _toggleSubtask(index),
                title: Text(
                  subtask.title,
                  style: TextStyle(
                    decoration:
                        subtask.isCompleted ? TextDecoration.lineThrough : null,
                    color: subtask.isCompleted ? Colors.grey : null,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
            SizedBox(height: 24),
          ],

          // Info cards
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  icon: Icons.calendar_today,
                  label: 'Rok',
                  value: widget.task.deadline != null
                      ? '${widget.task.deadline!.day}/${widget.task.deadline!.month}'
                      : 'Nema',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _InfoCard(
                  icon: Icons.priority_high,
                  label: 'Prioritet',
                  value: widget.task.priority.name,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Edit task
                  },
                  icon: Icon(Icons.edit),
                  label: Text('Uredi'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Zadatak označen kao završen')),
                    );
                  },
                  icon: Icon(Icons.check),
                  label: Text('Završi'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Create Task Dialog (Placeholder)
class CreateTaskDialog extends StatelessWidget {
  final String groupId;

  const CreateTaskDialog({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Novi zadatak'),
      content: Text('Forma za kreiranje zadatka (TODO)'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Otkaži'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Zadatak kreiran')),
            );
          },
          child: Text('Kreiraj'),
        ),
      ],
    );
  }
}
