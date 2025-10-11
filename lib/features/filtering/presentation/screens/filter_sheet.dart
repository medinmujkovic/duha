import 'package:duha_app/features/tasks/data/models/priority_model.dart';
import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  @override
  _FilterSheetState createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  Priority? _selectedPriority;
  String? _selectedProject;
  String? _selectedSection;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text('Priority', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: Priority.values.map((priority) {
              return FilterChip(
                label: Text(priority.name.toUpperCase()),
                selected: _selectedPriority == priority,
                onSelected: (selected) {
                  setState(() {
                    _selectedPriority = selected ? priority : null;
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          Text('Tags', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['work', 'personal', 'urgent', 'later'].map((tag) {
              return FilterChip(
                label: Text(tag),
                selected: false,
                onSelected: (selected) {},
              );
            }).toList(),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedPriority = null;
                      _selectedProject = null;
                      _selectedSection = null;
                    });
                  },
                  child: Text('Clear All'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}