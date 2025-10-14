// lib/presentation/group/group_detail_screen.dart
import 'package:duha_app/common/widgets/new_task_button.dart';
import 'package:duha_app/features/groups/presentation/widgets/group_task_detail_sheet.dart';
import 'package:duha_app/features/groups/presentation/widgets/info_card.dart';
import 'package:duha_app/features/tasks/data/models/task_enum.dart';
import 'package:duha_app/features/tasks/data/models/subtask_model.dart';
import 'package:duha_app/features/tasks/data/models/task_model.dart';
import 'package:duha_app/features/groups/presentation/widgets/group_task_card.dart';
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
      type: TaskType.allMembers,
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
      title: 'Dizajnirati kampanju na društvenim mrežama',
      description: 'Kreirati novi automatizirani sistem za izvještavanje',
      type: TaskType.specificMembers,
      assigneeIds: ['user1', 'user2', 'user3'],
      subtasks: [
        Subtask(id: '1', title: 'Istraživanje konkurencije', isCompleted: true),
        Subtask(id: '2', title: 'Skice i draft verzije', isCompleted: true),
        Subtask(id: '3', title: 'Finalna verzija', isCompleted: false),
      ],
      deadline: DateTime.now().add(Duration(days: 3)),
      priority: Priority.medium,
      completedByIds: ['user1'],
      createdAt: DateTime.now().subtract(Duration(days: 2)),
    ),
        Task(
      id: '3',
      groupId: 'group1',
      title: 'Iskopati nove kanale za promociju',
      description: 'Kanali koji su do sada zanemareni',
      type: TaskType.specificMembers,
      assigneeIds: ['user1', 'user2', 'user3'],
      subtasks: [
        Subtask(id: '1', title: 'Istraživanje konkurencije', isCompleted: true),
        Subtask(id: '2', title: 'Skice i draft verzije', isCompleted: true),
        Subtask(id: '3', title: 'Finalna verzija', isCompleted: false),
      ],
      deadline: DateTime.now().add(Duration(days: 3)),
      priority: Priority.low,
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
          ? const Center(
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
              padding: const EdgeInsets.all(16),
              itemCount: _mockTasks.length,
              itemBuilder: (context, index) {
                final task = _mockTasks[index];
                return GroupTaskCard(
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
