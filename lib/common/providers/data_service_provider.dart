// lib/features/tasks/presentation/providers/data_service_provider.dart
import 'package:duha_app/common/data_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duha_app/features/tasks/data/models/task/task_model.dart';
import 'package:duha_app/features/groups/data/models/group_model.dart';
import 'package:duha_app/features/notifications/data/models/notifications_model.dart';

final dataServiceProvider = Provider<DataService>((ref) {
  return DataService();
});

// Stream providers for real-time updates
final userGroupsStreamProvider = StreamProvider.family<List<Group>, String>((ref, userId) {
  final dataService = ref.watch(dataServiceProvider);
  return dataService.getUserGroupsStream(userId);
});

final groupTasksStreamProvider = StreamProvider.family<List<Task>, String>((ref, groupId) {
  final dataService = ref.watch(dataServiceProvider);
  return dataService.getTasksForGroupStream(groupId);
});

final userTasksStreamProvider = StreamProvider.family<List<Task>, String>((ref, userId) {
  final dataService = ref.watch(dataServiceProvider);
  return dataService.getTasksForUserStream(userId);
});

final userNotificationsStreamProvider = StreamProvider.family<List<Notifications>, String>((ref, userId) {
  final dataService = ref.watch(dataServiceProvider);
  return dataService.getNotificationsStream(userId);
});