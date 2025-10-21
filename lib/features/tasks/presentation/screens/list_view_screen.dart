import 'package:duha_app/common/widgets/new_task_button.dart';
import 'package:duha_app/core/util/task_utils.dart';
import 'package:duha_app/features/projects/data/models/section_model/section_model.dart';
import 'package:duha_app/features/tasks/data/datasources/data_service.dart';
import 'package:duha_app/features/tasks/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';

class CustomListView extends StatefulWidget {
  @override
  _CustomListViewState createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  final DataService _dataService = DataService();
  @override
  Widget build(BuildContext context) {
    final sections = _dataService.getSections();
    final tasks = _dataService.getTasks();

    return Scaffold(
      appBar: AppBar(
        title: Text('All Projects'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () => _showAddSectionDialog(context),
            tooltip: 'Add Section',
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: sections.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 80, color: Colors.grey[300]),
                  SizedBox(height: 16),
                  Text('No sections yet',
                      style: TextStyle(color: Colors.grey[600])),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _showAddSectionDialog(context),
                    child: Text('Create First Section'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                final sectionTasks = tasks
                    .where((t) => t.sectionId == section.id && !t.isCompleted)
                    .toList();

                return ExpansionTile(
                  initiallyExpanded: true,
                  leading: Icon(Icons.folder, color: Color(0xFF7C3AED)),
                  title: Text(
                    section.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${sectionTasks.length} tasks'),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'rename',
                        child: Text('Rename'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'rename') {
                        _showRenameSectionDialog(context, section);
                      } else if (value == 'delete') {
                        _dataService.deleteSection(section.id);
                        setState(() {});
                      }
                    },
                  ),
                  children: [
                    ...sectionTasks.map((task) => TaskCard(
                          task: task,
                          onTap: () {
                            showTaskDetail(context,_dataService, task, sectionId: section.id);
                          },
                          onToggle: () {
                            setState(() {
                              _dataService.toggleTaskCompletion(
                                  task.id, _dataService.getCurrentUser().id);
                            });
                          },
                        )),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: OutlinedButton.icon(
                        onPressed: () {
                          print(section.id);
                          showTaskCreate(context, null, sectionId: section.id);
                        },
                        icon: Icon(Icons.add),
                        label: Text('Add Task'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFF7C3AED),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: AddTaskButton(
        onPressed: () {
          showTaskCreate(context, null);
        },
      ),
    );
  }

  void _showAddSectionDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Section'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Section name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _dataService.addSection(controller.text);
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showRenameSectionDialog(BuildContext context, SectionModel section) {
    final controller = TextEditingController(text: section.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename Section'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Section name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _dataService.renameSection(section.id, controller.text);
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    final filteredTasks = _dataService.getCompletedTasks();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                'All Completed Tasks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              ...filteredTasks.map((task) {
                return Card(
                  margin: EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green[100],
                      child: Icon(Icons.check, color: Colors.green[700]),
                    ),
                    title: Text(task.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.groupId ?? 'No Group'),
                        Text(
                          'Completed by: ${task.completedByIds.join(", ")}',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '${task.completedAt!.day}/${task.completedAt!.month}/${task.completedAt!.year}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text('+${task.xpReward}'),
                      backgroundColor: Colors.amber[100],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
