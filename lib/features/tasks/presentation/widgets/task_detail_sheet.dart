import 'package:duha_app/core/util/task_utils.dart';
import 'package:duha_app/features/auth/presentation/providers/user_provider.dart';
import 'package:duha_app/features/groups/presentation/widgets/info_card.dart';
import 'package:duha_app/features/tasks/data/datasources/data_service.dart';
import 'package:duha_app/features/tasks/data/models/subtask/subtask_model.dart';
import 'package:duha_app/features/tasks/data/models/task/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskDetailSheet extends ConsumerStatefulWidget {
  final Task task;
  final ScrollController scrollController;

  const TaskDetailSheet({
    super.key,
    required this.task,
    required this.scrollController,
    required DataService dataService,
    String? sectionId,
  });

  @override
  ConsumerState<TaskDetailSheet> createState() => _TaskDetailSheetState();
}

class _TaskDetailSheetState extends ConsumerState<TaskDetailSheet> {
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
    final user = ref.watch(userProvider);

    return Container(
      padding: const EdgeInsets.all(24),
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
          const SizedBox(height: 24),

          // Title
          Text(
            widget.task.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Description
          ...[
          Text(
            widget.task.description,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 24),
        ],

          // Progress (if has subtasks)
          if (_subtasks.isNotEmpty) ...[
            const Text(
              'Progres',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 8),
            Text(
              '$completedCount/${_subtasks.length} podzadataka završeno (${(progress * 100).toInt()}%)',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // Subtasks list
            const Text(
              'Podzadaci',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
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
            }),
            const SizedBox(height: 24),
          ],

          // Info cards
          Row(
            children: [
              Expanded(
                child: InfoCard(
                  icon: Icons.calendar_today,
                  label: 'Rok',
                  value: widget.task.deadline != null
                      ? '${widget.task.deadline!.day}/${widget.task.deadline!.month}'
                      : 'Nema',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InfoCard(
                  icon: Icons.priority_high,
                  label: 'Prioritet',
                  value: widget.task.priority.name,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    showTaskCreate(context, null,user?.id , task: widget.task);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Uredi'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Zadatak označen kao završen')),
                    );
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Završi'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
