import 'package:duha_app/common/providers/data_service_provider.dart';
import 'package:duha_app/common/widgets/new_task_button.dart';
import 'package:duha_app/core/util/task_utils.dart';
import 'package:duha_app/features/auth/presentation/providers/user_provider.dart';
import 'package:duha_app/features/projects/data/models/section_model/section_model.dart';
import 'package:duha_app/features/tasks/data/models/task/task_model.dart';
import 'package:duha_app/features/tasks/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomListView extends ConsumerStatefulWidget {
  const CustomListView({super.key});

  @override
  _CustomListViewState createState() => _CustomListViewState();
}

class _CustomListViewState extends ConsumerState<CustomListView> {

  @override
  Widget build(BuildContext context) {
    final dataService = ref.read(dataServiceProvider);
    final user = ref.read(userProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('User not authenticated')),
      );
    }

  final sectionsStream = dataService.getSectionsStream(user.id!);
  final tasksStream = dataService.getTasksForUserStream(user.id!);

    return StreamBuilder<List<Section>>(
      stream: sectionsStream,
      builder: (context, secSnap) {
        if (secSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (secSnap.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${secSnap.error}')));
        }

        final sections = secSnap.data ?? <Section>[];

        if (sections.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('All Projects'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_box_outlined),
                  onPressed: () => _showAddSectionDialog(context),
                  tooltip: 'Add Section',
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => _showFilterSheet(context),
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('No sections yet', style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _showAddSectionDialog(context),
                    child: const Text('Create First Section'),
                  ),
                ],
              ),
            ),
            floatingActionButton: AddTaskButton(
              onPressed: () {
                showTaskCreate(context, null, user.id);
              },
            ),
          );
        }

        return StreamBuilder<List<Task>>(
          stream: tasksStream,
          builder: (context, taskSnap) {
            if (taskSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (taskSnap.hasError) {
              return Scaffold(body: Center(child: Text('Error: ${taskSnap.error}')));
            }

            final tasks = taskSnap.data ?? <Task>[];

            return Scaffold(
              appBar: AppBar(
                title: const Text('All Projects'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add_box_outlined),
                    onPressed: () => _showAddSectionDialog(context),
                    tooltip: 'Add Section',
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () => _showFilterSheet(context),
                  ),
                ],
              ),
              body: ListView.builder(
                itemCount: sections.length,
                itemBuilder: (context, index) {
                  final section = sections[index];
                  final sectionTasks = tasks.where((t) => t.sectionId == section.id && !t.isCompleted).toList();

                  return ExpansionTile(
                    initiallyExpanded: true,
                    leading: const Icon(Icons.folder, color: Color(0xFF7C3AED)),
                    title: Text(
                      section.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                          dataService.deleteSection(section.id);
                          setState(() {});
                        }
                      },
                    ),
                    children: [
                      ...sectionTasks.map((task) => TaskCard(
                            task: task,
                            onTap: () {
                              showTaskDetail(context, dataService, task, sectionId: section.id);
                            },
                            onToggle: () {
                              setState(() {
                                dataService.toggleTaskCompletion(taskId: task.id, userId: user.id!, ref: ref);
                              });
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            showTaskCreate(context, null, user.id!, sectionId: section.id);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Task'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF7C3AED),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              floatingActionButton: AddTaskButton(
                onPressed: () {
                  showTaskCreate(context, null, user.id!);
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showAddSectionDialog(BuildContext context) {
    final dataService = ref.read(dataServiceProvider);
    final user = ref.read(userProvider);
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Section'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Section name'),
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
                dataService.addSection(controller.text, user?.id ?? '');
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showRenameSectionDialog(BuildContext context, Section section) {
    final dataService = ref.read(dataServiceProvider);
    final controller = TextEditingController(text: section.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Section'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Section name'),
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
                dataService.renameSection(section.id, controller.text);
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showFilterSheet(BuildContext context) async {
    final dataService = ref.read(dataServiceProvider);
    final user = ref.read(userProvider);
    final filteredTasks = await dataService.getCompletedTasks(user!.id!);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'All Completed Tasks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...filteredTasks.map((task) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
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
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          '${task.completedAt!.day}/${task.completedAt!.month}/${task.completedAt!.year}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text('+${task.xpReward}'),
                      backgroundColor: Colors.amber[100],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
