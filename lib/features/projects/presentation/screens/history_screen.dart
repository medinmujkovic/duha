import 'package:duha_app/common/providers/data_service_provider.dart';
import 'package:duha_app/features/auth/presentation/providers/user_provider.dart';
import 'package:duha_app/features/tasks/data/models/task/task_model.dart';
import 'package:flutter/material.dart';
import 'package:duha_app/features/tasks/presentation/widgets/summary_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  
  String _selectedPeriod = 'week'; // 'week' or 'month'

  @override
  Widget build(BuildContext context) {
    final dataService = ref.read(dataServiceProvider);
    final user = ref.read(userProvider);

    return FutureBuilder<List<Task>>(
      future: dataService.getCompletedTasks(user!.id!),
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

        final completedTasks = snapshot.data ?? <Task>[];
        final now = DateTime.now();

        final filteredTasks = completedTasks.where((task) {
          if (task.completedAt == null) return false;
          final diff = now.difference(task.completedAt!);
          return _selectedPeriod == 'week' ? diff.inDays <= 7 : diff.inDays <= 30;
        }).toList();

        final totalXP = filteredTasks.fold<int>(0, (sum, task) => sum + task.xpReward);

        final tasksByProject = <String, List<Task>>{};
        for (var task in filteredTasks) {
          tasksByProject.putIfAbsent(task.groupId ?? '0', () => []).add(task);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Task History'),
            actions: [
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'week', label: Text('Week')),
                  ButtonSegment(value: 'month', label: Text('Month')),
                ],
                selected: {_selectedPeriod},
                onSelectionChanged: (Set<String> selection) {
                  setState(() {
                    _selectedPeriod = selection.first;
                  });
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Export feature coming soon!')),
                  );
                },
              ),
            ],
          ),
          body: filteredTasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'No completed tasks yet',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Summary Cards
                    Row(
                      children: [
                        Expanded(
                          child: buildSummaryCard(
                            'Tasks Completed',
                            filteredTasks.length.toString(),
                            Icons.check_circle,
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: buildSummaryCard(
                            'XP Earned',
                            totalXP.toString(),
                            Icons.star,
                            Colors.amber,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // By Project Section
                    const Text(
                      'Completed by Project',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...tasksByProject.entries.map((entry) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ExpansionTile(
                          leading: const Icon(Icons.folder, color: Color(0xFF7C3AED)),
                          title: Text(
                            entry.key,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('${entry.value.length} tasks'),
                          children: entry.value.map((task) {
                            return ListTile(
                              leading: const Icon(Icons.check_circle, color: Colors.green),
                              title: Text(task.title),
                              subtitle: Text(
                                'Completed: ${task.completedAt!.day}/${task.completedAt!.month} '
                                '${task.completedAt!.hour}:${task.completedAt!.minute.toString().padLeft(2, '0')}',
                              ),
                              trailing: Chip(
                                label: Text('+${task.xpReward} XP'),
                                backgroundColor: Colors.amber[100],
                                labelStyle: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }),

                    const SizedBox(height: 16),
                    const Text(
                      'All Completed Tasks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
