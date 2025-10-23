import 'dart:math';

import 'package:duha_app/features/auth/data/models/user_model.dart';
import 'package:duha_app/features/projects/data/models/project_model/project_model.dart';
import 'package:duha_app/features/projects/data/models/section_model/section_model.dart';
import 'package:duha_app/features/projects/data/models/user_activity_model/user_activity_model.dart';
import 'package:duha_app/features/tasks/data/models/task_enum.dart';
import 'package:duha_app/features/tasks/data/models/task_model.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final List<Task> _tasks = [];
  final List<SectionModel> _sections = [];
  final List<GroupModel> _groups = [];
  final UserModel _currentUser = UserModel(
    id: '1',
    name: 'You',
    email: 'you@example.com',
    avatar: 'Y',
    level: 12,
    xp: 2450,
    streak: 7,
  );

  UserModel getCurrentUser() => _currentUser;

  List<Task> getTasks() => _tasks;

  List<Task> getTasksForGroup(String groupId) =>
      _tasks.where((t) => t.groupId == groupId).toList();

  List<Task> getCompletedTasks() =>
      _tasks.where((t) => t.isCompleted).toList();

  List<SectionModel> getSections() =>
      _sections..sort((a, b) => a.order.compareTo(b.order));

  List<GroupModel> getGroups(String id) => _groups.where((g) => g.memberIds.contains(id)).toList();

  List<UserActivity> getLeaderboard(String id ) {
    final userActivities = <UserActivity>[];

    for (var group in getGroups(id)) {
      for (var memberId in group.memberIds) {
        // Simulate fetching user activity data
        userActivities.add(UserActivity(
          id: memberId,
          username: 'User $memberId',
          groupId: group.id,
          userId: memberId,
          xp: Random().nextInt(5000).toString(),
          level: Random().nextInt(20).toString(),
          streak: Random().nextInt(30).toString(),
        ));
      }
    }

    userActivities.sort((a, b) => int.parse(b.xp).compareTo(int.parse(a.xp)));

    return userActivities;

  }

  List<UserActivity> getRecentActivities() {
    final activities = <UserActivity>[];

    // Simulate recent activities
    for (int i = 0; i < 10; i++) {
      activities.add(UserActivity(
        id: 'activity_$i',
        username: 'User ${i + 1}',
        groupId: 'group_1',
        userId: 'user_${Random().nextInt(5) + 1}',
        xp: Random().nextInt(500).toString(),
        level: Random().nextInt(20).toString(),
        streak: Random().nextInt(30).toString(),
      ));
    }

    return activities;
  }



  void addTask({
    required String title,
    String description = '',
    Priority priority = Priority.medium,
    DateTime? deadline,
    String? repeat,
    String? sectionId,
    String? groupId,
    TaskType? taskType,
    required List<String> assigneeIds,
  }) {
    _tasks.add(Task(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      priority: priority,
      deadline: deadline,
      repeat: repeat,
      groupId: groupId,
      assigneeIds: assigneeIds,
      type: taskType,
      sectionId: sectionId,
      createdAt: DateTime.now(),
      xpReward: priority == Priority.urgent
          ? 100
          : priority == Priority.high
              ? 80
              : priority == Priority.medium
                  ? 50
                  : 30,
    ));
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
  }

  void toggleTaskCompletion(String taskId, String userId) {
    final task = _tasks.firstWhere((t) => t.id == taskId);

    if (task.completedByIds.contains(userId)) {
      task.completedByIds.remove(userId);
    } else {
      task.completedByIds.add(userId);
    }

    if (task.isCompleted && task.completedAt == null) {
      task.completedAt = DateTime.now();
      _currentUser.xp += task.xpReward;

      // Level up check
      if (_currentUser.xp >= 3000) {
        _currentUser.level++;
        _currentUser.xp -= 3000;
      }
    } else if (!task.isCompleted) {
      task.completedAt = null;
    }
  }

  void addSection(String name) {
    _sections.add(SectionModel(
      id: Random().nextInt(100000).toString(),
      name: name,
      order: _sections.length,
    ));
  }

  void deleteSection(String sectionId) {
    _sections.removeWhere((s) => s.id == sectionId);
  }

  void renameSection(String sectionId, String newName) {
    final section = _sections.firstWhere((s) => s.id == sectionId);
    section.name = newName;
  }

  void addGroup(String name, String color) {
    _groups.add(GroupModel(
      id: DateTime.now().toString(),
      name: name,
      color: color,
      memberIds: ['You'],
      shareLink:
          'https://projectnova.app/join/${DateTime.now().millisecondsSinceEpoch}',
      isShared: true,
    ));
  }

  void addGroupMembers(String groupId, List<String> memberIds) {
    final group = _groups.firstWhere((g) => g.id == groupId);
    group.memberIds.addAll(memberIds);
  }

  getUserName(String id) {}

}
