import 'dart:math';
import 'package:duha_app/features/auth/data/models/user_model.dart';
import 'package:duha_app/features/projects/data/models/project_model/project_model.dart';
import 'package:duha_app/features/projects/data/models/section_model/section_model.dart';
import 'package:duha_app/features/tasks/data/models/task_enum.dart';
import 'package:duha_app/features/tasks/data/models/task_model.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final List<Task> _tasks = [];
  final List<SectionModel> _sections = [];
  final List<GroupModel> _groups = [];
  UserModel _currentUser = UserModel(
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

  List<UserModel> getLeaderboard(String id ) {
    final userActivities = <UserModel>[];

    for (var group in getGroups(id)) {
      for (var memberId in group.memberIds) {
        // Simulate fetching user activity data
        userActivities.add(UserModel(
          id: memberId,
          xp: Random().nextInt(5000),
          level: Random().nextInt(20),
          streak: Random().nextInt(30), name: '', email: '', avatar: '',
        ));
      }
    }

    userActivities.sort((a, b) => int.parse(b.xp as String).compareTo(int.parse(a.xp as String)));

    return userActivities;

  }

  List<UserModel> getRecentActivities() {
    final activities = <UserModel>[];

    // Simulate recent activities
    for (int i = 0; i < 10; i++) {
      activities.add(UserModel(
        id: 'activity_$i',
        xp: Random().nextInt(500),
        level: Random().nextInt(20),
        streak: Random().nextInt(30), name: '', email: '', avatar: '',
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
      _currentUser = _currentUser.copyWith(
        xp: _currentUser.xp + task.xpReward,
      );

      // Level up check
      if (_currentUser.xp >= 3000) {
        _currentUser = _currentUser.copyWith(
          level: _currentUser.level + 1,
          xp: _currentUser.xp - 3000,
        );
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
