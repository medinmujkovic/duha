import 'package:duha_app/features/tasks/data/datasources/data_service.dart';
import 'package:duha_app/features/tasks/data/models/task_enum.dart';
import 'package:duha_app/features/tasks/data/models/task_model.dart';
import 'package:flutter/material.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  final String? sectionId;

  AddEditTaskScreen({this.task, this.sectionId});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final DataService _dataService = DataService();

  Priority _selectedPriority = Priority.medium;
  DateTime? _selectedDeadline;
  String? _selectedRepeat;
  String? _selectedSectionId;
  List<String> _selectedAssignees = [];
  List<String> _availableAssignees = ['You', 'Sarah', 'Ahmed', 'Alex', 'Team'];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedPriority = widget.task!.priority;
      _selectedDeadline = widget.task!.deadline;
      _selectedRepeat = widget.task!.repeat;
      _selectedSectionId = widget.task!.sectionId;
      _selectedAssignees = List.from(widget.task!.assigneeIds);
    } else {
      _selectedSectionId = widget.sectionId;
      _selectedAssignees = ['You'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Task Title *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<Priority>(
              value: _selectedPriority,
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: Priority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Deadline'),
              subtitle: Text(_selectedDeadline == null
                  ? 'No deadline'
                  : '${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year}'),
              trailing: Icon(Icons.calendar_today),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDeadline ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _selectedDeadline = date;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRepeat,
              decoration: InputDecoration(
                labelText: 'Repeat',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: [
                DropdownMenuItem(value: null, child: Text('No repeat')),
                DropdownMenuItem(value: 'daily', child: Text('Daily')),
                DropdownMenuItem(value: 'weekdays', child: Text('Weekdays')),
                DropdownMenuItem(
                    value: 'every-2-days', child: Text('Every 2 days')),
                DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRepeat = value;
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSectionId,
              decoration: InputDecoration(
                labelText: 'Section',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: [
                DropdownMenuItem(value: null, child: Text('No section')),
                ..._dataService.getSections().map((section) {
                  return DropdownMenuItem(
                    value: section.id,
                    child: Text(section.name),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSectionId = value;
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'Assignees',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _availableAssignees.map((assignee) {
                final isSelected = _selectedAssignees.contains(assignee);
                return FilterChip(
                  label: Text(assignee),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedAssignees.add(assignee);
                      } else {
                        _selectedAssignees.remove(assignee);
                      }
                    });
                  },
                  selectedColor: Color(0xFF7C3AED).withOpacity(0.3),
                );
              }).toList(),
            ),
            if (_selectedAssignees.length > 1) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'All assignees must complete this task',
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
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                widget.task == null ? 'Create Task' : 'Save Changes',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      if (widget.task == null) {
        // Create new task
        _dataService.addTask(
          title: _titleController.text,
          description: _descriptionController.text,
          priority: _selectedPriority,
          deadline: _selectedDeadline,
          repeat: _selectedRepeat,
          sectionId: _selectedSectionId,
          assigneeIds: _selectedAssignees,
        );
      } else {
        // Update existing task
        widget.task!.title = _titleController.text;
        widget.task!.description = _descriptionController.text;
        widget.task!.priority = _selectedPriority;
        widget.task!.deadline = _selectedDeadline;
        widget.task!.repeat = _selectedRepeat;
        widget.task!.sectionId = _selectedSectionId;
        widget.task!.assigneeIds = _selectedAssignees;
      }
      Navigator.pop(context);
    }
  }
}