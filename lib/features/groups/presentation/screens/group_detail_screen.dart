// lib/presentation/group/group_detail_screen.dart
import 'package:duha_app/common/widgets/new_task_button.dart';
import 'package:duha_app/core/util/task_utils.dart';
import 'package:duha_app/features/tasks/data/datasources/data_service.dart';
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

  final DataService _dataService = DataService();
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


  @override
  Widget build(BuildContext context) {

    final tasks = _dataService.getTasksForGroup(widget.groupId);


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
      body: tasks.isEmpty
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
              itemCount: tasks.where((t) => !t.isCompleted).take(5).length,
              itemBuilder: (context, index) {
                final task = tasks.where((t) => !t.isCompleted).toList()[index];
                return GroupTaskCard(
                  task: task,
                  onTap: () => showTaskDetail(context,_dataService, task),
                );
              },
            ),
      floatingActionButton: AddTaskButton(
        onPressed: () {
          showTaskCreate(context, widget.groupId);
        },
      ),
    );
  }

}

