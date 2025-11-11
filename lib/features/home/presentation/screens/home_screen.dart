import 'package:duha_app/common/providers/data_service_provider.dart';
import 'package:duha_app/common/widgets/new_task_button.dart';
import 'package:duha_app/common/widgets/signout_button.dart';
import 'package:duha_app/core/constants/app_constants.dart';
import 'package:duha_app/core/util/task_utils.dart';
import 'package:duha_app/features/auth/presentation/providers/user_provider.dart';
import 'package:duha_app/features/filtering/presentation/screens/filter_sheet.dart';
import 'package:duha_app/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:duha_app/features/tasks/presentation/screens/task_detail_screen.dart';
import 'package:duha_app/features/tasks/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duha_app/features/tasks/data/models/task/task_model.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  
  @override
  Widget build(BuildContext context) {
    final dataService = ref.read(dataServiceProvider);
    final user = ref.watch(userProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text(AppMessages.noUserLoggedIn)),
      );
    }

    final tasksStream = dataService.getTasksForUserStream(user.id ?? '0');

    return StreamBuilder<List<Task>>(
      stream: tasksStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

    final tasksList = snapshot.data ?? <Task>[];
    final incompleteTasks = tasksList.where((t) => !t.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(AppMessages.appName, style: TextStyle(fontSize: 20)),
            Text('${AppMessages.welcome} ${user.name}',
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterSheet(context);
            },
          ),
          const SignOutButton(isIconOnly: true),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Banner
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppMessages.cheering,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Keep your ${user.streak}-day streak alive. ${incompleteTasks.length} tasks remaining.',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Stats Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      AppMessages.level,
                      user.level.toString(),
                      Icons.emoji_events,
                      Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      AppMessages.streak,
                      '${user.streak}d',
                      Icons.local_fire_department,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      AppMessages.xp,
                      user.xp.toString(),
                      Icons.star,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Today's Tasks
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    AppMessages.todaysTasks,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      showTaskCreate(context, null,user.id);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text(AppMessages.add),
                  ),
                ],
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: incompleteTasks.length > 5 ? 5 : incompleteTasks.length,
              itemBuilder: (context, index) {
                final task = incompleteTasks[index];
                return TaskCard(
                  task: task,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(task: task),
                      ),
                    );
                  },
                  onToggle: () {
                    setState(() {
                      dataService.toggleTaskCompletion(
                          taskId:task.id, userId: user.id ?? '0',ref:ref);
                    });
                  },
                );
              },
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
      },
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const FilterSheet(),
    );
  }
}
