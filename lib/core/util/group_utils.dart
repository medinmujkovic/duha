


import 'package:duha_app/features/groups/data/models/group_model.dart';
import 'package:duha_app/features/groups/presentation/widgets/group_settings_sheet.dart';
import 'package:duha_app/features/tasks/data/datasources/data_service.dart';
import 'package:flutter/material.dart';

void showGroupSettings(BuildContext context, DataService dataService, Group group) {
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
        builder: (context, scrollController) => GroupSettingsSheet(
          scrollController: scrollController, dataService: dataService, 
           group: group,
        ),
      ),
    );
  }
