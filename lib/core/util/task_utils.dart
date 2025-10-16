  import 'package:duha_app/features/tasks/presentation/widgets/task_detail_sheet.dart';
import 'package:duha_app/features/tasks/data/datasources/data_service.dart';
import 'package:duha_app/features/tasks/data/models/task_model.dart';
import 'package:duha_app/features/tasks/presentation/widgets/task_create_sheet.dart';
import 'package:flutter/material.dart';

void showTaskDetail(BuildContext context, DataService dataService, Task task,{ sectionId }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => TaskDetailSheet(
          task: task,
          scrollController: scrollController, dataService: dataService, 
          sectionId: sectionId,
        ),
      ),
    );
  }

    void showTaskCreate(BuildContext context, String? groupId, { sectionId, task } ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => TaskCreateSheet(
          scrollController: scrollController, groupId: groupId, sectionId: sectionId ?? task?.sectionId, task: task,
        ),
      ),
    );
  }