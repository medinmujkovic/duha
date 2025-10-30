import 'package:duha_app/features/groups/data/models/group_model.dart';
import 'package:duha_app/features/tasks/data/datasources/data_service.dart';
import 'package:flutter/material.dart';

class GroupSettingsSheet extends StatefulWidget {
  final Group group;
  final ScrollController scrollController;

  const GroupSettingsSheet({
    super.key,
    required this.group,
    required this.scrollController,
    required DataService dataService,
  });

  @override
  State< GroupSettingsSheet> createState() => _GroupSettingsSheetState();
}

class _GroupSettingsSheetState {
}