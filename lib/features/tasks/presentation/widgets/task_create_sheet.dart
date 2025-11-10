import 'package:duha_app/common/utils/priority_colors.dart';
import 'package:duha_app/features/auth/data/models/user_model.dart';
import 'package:duha_app/common/data_service.dart';
import 'package:duha_app/features/tasks/data/enums/task_enum.dart';
import 'package:flutter/material.dart';
import '../../data/models/task/task_model.dart';


class TaskCreateSheet extends StatefulWidget {
  final ScrollController scrollController;
  final String? groupId;
  final Task? task; // Ako editujemo postojeći task
  final String? sectionId;  
  final String? userId;

  const TaskCreateSheet({
    super.key,
    required this.scrollController,
    this.userId,
    this.groupId,    
    this.sectionId,
    this.task,

  });

  @override
  State<TaskCreateSheet> createState() => _TaskCreateSheetState();
}

class _TaskCreateSheetState extends State<TaskCreateSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final DataService _dataService = DataService();

  TaskType _selectedTaskType = TaskType.allMembers;
  Priority _selectedPriority = Priority.medium;
  DateTime? _selectedDeadline;
  String? _selectedRepeat;
  List<String> _selectedAssignees = [];
  List<UserModel> _availableAssignees = [];
  

  @override
  void initState() {
    super.initState();
      _availableAssignees = _dataService.getGroupMembers(widget.groupId!);
    if (widget.task != null) {
      // Edit mode
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _selectedTaskType = widget.task!.type!;
      _selectedPriority = widget.task!.priority;
      _selectedDeadline = widget.task!.deadline;
      _selectedAssignees = List.from(widget.task!.assigneeIds ?? []);
    } else {
      // Create mode
      _selectedAssignees = [];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
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
              isEditing ? 'Uredi zadatak' : 'Kreiraj novi zadatak',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Task Title Field
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Naziv zadatka *',
                hintText: 'Npr. Dizajnirati logo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.task_alt),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Molimo unesite naziv zadatka';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Description Field
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Opis',
                hintText: 'Detalji o zadatku...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.notes),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textInputAction: TextInputAction.newline,
            ),
            const SizedBox(height: 24),

            // Task Type Selection
            const Text(
              'Tip zadatka',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _TaskTypeCard(
                    title: 'Svi članovi',
                    subtitle: 'Svi moraju završiti',
                    icon: Icons.groups,
                    isSelected: _selectedTaskType == TaskType.allMembers,
                    onTap: () {
                      setState(() {
                        _selectedTaskType = TaskType.allMembers;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TaskTypeCard(
                    title: 'Bilo ko',
                    subtitle: 'Jedan član završi',
                    icon: Icons.person,
                    isSelected: _selectedTaskType == TaskType.specificMembers,
                    onTap: () {
                      setState(() {
                        _selectedTaskType = TaskType.specificMembers;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Priority Dropdown
            DropdownButtonFormField<Priority>(
              initialValue: _selectedPriority,
              decoration: InputDecoration(
                labelText: 'Prioritet',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.flag),
              ),
              items: Priority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: getPriorityColor(priority),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(priority.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Deadline Picker
            InkWell(
              onTap: _pickDeadline,
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Rok',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: _selectedDeadline != null
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            setState(() {
                              _selectedDeadline = null;
                            });
                          },
                        )
                      : null,
                ),
                child: Text(
                  _selectedDeadline == null
                      ? 'Bez roka'
                      : '${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year}',
                  style: TextStyle(
                    fontSize: 16,
                    color: _selectedDeadline == null
                        ? Colors.grey[600]
                        : Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Repeat Dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedRepeat,
              decoration: InputDecoration(
                labelText: 'Ponavljanje',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.repeat),
              ),
              items: const [
                DropdownMenuItem(value: null, child: Text('Bez ponavljanja')),
                DropdownMenuItem(value: 'daily', child: Text('Dnevno')),
                DropdownMenuItem(value: 'weekdays', child: Text('Radni dani')),
                DropdownMenuItem(
                    value: 'every-2-days', child: Text('Svaka 2 dana')),
                DropdownMenuItem(value: 'weekly', child: Text('Sedmično')),
                DropdownMenuItem(value: 'monthly', child: Text('Mjesečno')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRepeat = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // Assignees Section
            const Text(
              'Dodijeli članovima',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableAssignees.map((assignee) {
                final isSelected = _selectedAssignees.contains(assignee.id);
                return FilterChip(
                  label: Text(assignee.id == widget.userId ? 'You' : assignee.name!),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedAssignees.add(assignee.id!);
                      } else {
                        if (_selectedAssignees.length > 1) {
                          _selectedAssignees.remove(assignee.id);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mora biti najmanje jedan član'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    });
                  },
                  selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  checkmarkColor: Theme.of(context).colorScheme.primary,
                  avatar: isSelected
                      ? Icon(
                          Icons.check_circle,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                );
              }).toList(),
            ),

            // Info banner for All Members task
            if (_selectedTaskType == TaskType.allMembers &&
                _selectedAssignees.length > 1) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Svi dodijeljeni članovi moraju završiti ovaj zadatak',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Info banner for Any Member task
            if (_selectedTaskType == TaskType.specificMembers &&
                _selectedAssignees.length > 1) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.purple[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Dovoljno je da jedan član završi ovaj zadatak',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Otkaži'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: _saveTask,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Sačuvaj promjene' : 'Kreiraj zadatak',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }


  Future<void> _pickDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _selectedDeadline = date;
      });
    }
  }

  void _saveTask() {
    print ('Saving task...');
    if (_formKey.currentState!.validate()) {
      if (widget.task == null) {
        // Create new task
        _dataService.addTask(
          title: _titleController.text,
          description: _descriptionController.text,
          priority: _selectedPriority,
          deadline: _selectedDeadline,
          repeat: _selectedRepeat,
          sectionId: widget.sectionId,
          assigneeIds: _selectedAssignees,
          groupId: widget.groupId,
          taskType: _selectedTaskType,
        );
      } else {
        // Update existing task
          _dataService.updateTask(
            id: widget.task!.id,
            title: _titleController.text,
            description: _descriptionController.text,
            priority: _selectedPriority,
            deadline: _selectedDeadline,
            repeat: _selectedRepeat,
            sectionId: widget.sectionId,
            assigneeIds: _selectedAssignees,
            groupId: widget.groupId,
            taskType: _selectedTaskType,
          );       
      }
      Navigator.pop(context);
    }
  }
}

// Custom Task Type Card Widget
class _TaskTypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TaskTypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected ? Theme.of(context).colorScheme.primary : null,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}