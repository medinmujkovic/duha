
import 'package:duha_app/features/tasks/data/enums/task_enum.dart';
import 'package:flutter/material.dart';

Color getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.urgent:
        return Colors.red;
      case Priority.high:
        return Colors.orange;
      case Priority.medium:
        return Colors.yellow[700]!;
      case Priority.low:
        return Colors.green;
    }
  }