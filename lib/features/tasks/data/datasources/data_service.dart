import 'dart:math';
import 'package:duha_app/features/auth/data/models/user_model.dart';
import 'package:duha_app/features/auth/presentation/providers/user_provider.dart';
import 'package:duha_app/features/groups/data/models/group_model.dart';
import 'package:duha_app/features/notifications/data/models/notification_enum.dart';
import 'package:duha_app/features/notifications/data/models/notifications_model.dart';
import 'package:duha_app/features/notifications/data/models/token_model.dart';
import 'package:duha_app/features/projects/data/models/section_model/section_model.dart';
import 'package:duha_app/features/tasks/data/enums/task_enum.dart';
import 'package:duha_app/features/tasks/data/models/task/task_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataService extends ChangeNotifier {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final List<Task> _tasks = [];
  final List<SectionModel> _sections = [];
  final List<Group> _groups = [];
  final List<Token> _tokens = [];
  final List<Notifications> _notifications = [
    Notifications(
      id: '2',
      userId: '1',
      name: 'Sara',
      content: 'just leveled up and earned 50 XP!',
      groupId: null,
      type: NotificationType.friendsUpdate,
      viewed: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Notifications(
      id: '4',
      userId: '1',
      name: 'Leo',
      content: 'completed the 7-day streak! 🔥',
      groupId: null,
      type: NotificationType.friendsUpdate,
      viewed: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];
  final List<UserModel> _users = [
    const UserModel(
        id: '1',
        name: 'amar',
        email: 'a@gmail.com',
        password: 'admin123!',
        avatar: '',
        level: 1,
        xp: 0,
        streak: 0),
    const UserModel(
        id: '2',
        name: 'amar2',
        email: 'a2@gmail.com',
        password: 'admin123!',
        avatar: '',
        level: 1,
        xp: 0,
        streak: 0)
  ];

  UserModel createUser(
      String name, String email, String password, String avatar) {
    final user = UserModel(
        id: Random().nextInt(100000).toString(),
        name: name,
        email: email,
        avatar: avatar,
        xp: 0,
        level: 1,
        streak: 0,
        password: password);
    _users.add(user);
    notifyListeners();
    return user;
  }

  List<Task> getTasks() => _tasks;

  List<Task> getTasksForGroup(String groupId) =>
      _tasks.where((t) => t.groupId == groupId).toList();

  List<Task> getCompletedTasks() => _tasks.where((t) => t.isCompleted).toList();

  List<SectionModel> getSections() =>
      _sections..sort((a, b) => a.order.compareTo(b.order));

  List<Group> getUserGroups(String id) =>
      _groups.where((g) => g.memberIds.contains(id)).toList();

  List<UserModel> getLeaderboard(String id) {
    final userActivities = <UserModel>[];

    for (var group in getUserGroups(id)) {
      for (var memberId in group.memberIds) {
        userActivities.add(UserModel(
            id: memberId,
            xp: Random().nextInt(5000),
            level: Random().nextInt(20),
            streak: Random().nextInt(30),
            name: '',
            email: '',
            avatar: '',
            password: ""));
      }
    }

    userActivities.sort((a, b) =>
        int.parse(b.xp as String).compareTo(int.parse(a.xp as String)));

    return userActivities;
  }

  List<Notifications> getActivitiesForUser(String id) {
    return _notifications.where((n) => n.userId == id).toList();
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
    notifyListeners(); // ✅ Added
  }

  void updateTask({
    required String id,
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
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) {
      throw Exception('Task with id=$id not found');
    }

    final current = _tasks[idx];

    final updated = current.copyWith(
      title: title,
      description: description.isEmpty ? current.description : description,
      priority: priority,
      deadline: deadline ?? current.deadline,
      repeat: repeat ?? current.repeat,
      sectionId: sectionId ?? current.sectionId,
      groupId: groupId ?? current.groupId,
      type: taskType ?? current.type,
      assigneeIds: assigneeIds,
    );

    _tasks[idx] = updated;
    notifyListeners(); // ✅ Added
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners(); // ✅ Added
  }

  void toggleTaskCompletion({
    required String taskId,
    required String userId,
    required WidgetRef ref,
  }) {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx == -1) return;

    final task = _tasks[idx];
    final isAlreadyCompleted = task.completedByIds.contains(userId);

    final updatedCompletedByIds = List<String>.from(task.completedByIds);
    if (isAlreadyCompleted) {
      updatedCompletedByIds.remove(userId);
    } else {
      updatedCompletedByIds.add(userId);
    }

    var updatedTask = task.copyWith(completedByIds: updatedCompletedByIds);

    if (updatedTask.isCompleted && updatedTask.completedAt == null) {
      updatedTask = updatedTask.copyWith(completedAt: DateTime.now());

      ref.read(userProvider.notifier).updateUser((u) {
        if (u == null) return u;

        int newXp = u.xp + updatedTask.xpReward;
        int newLevel = u.level;

        while (newXp >= 3000) {
          newLevel += 1;
          newXp -= 3000;
        }

        return u.copyWith(xp: newXp, level: newLevel);
      });
    } else if (!updatedTask.isCompleted) {
      updatedTask = updatedTask.copyWith(completedAt: null);
    }

    _tasks[idx] = updatedTask;
    notifyListeners(); // ✅ Added
  }

  void addSection(String name) {
    _sections.add(SectionModel(
      id: Random().nextInt(100000).toString(),
      name: name,
      order: _sections.length,
    ));
    notifyListeners(); // ✅ Added
  }

  void deleteSection(String sectionId) {
    _sections.removeWhere((s) => s.id == sectionId);
    notifyListeners(); // ✅ Added
  }

  void renameSection(String sectionId, String newName) {
    final section = _sections.firstWhere((s) => s.id == sectionId);
    section.name = newName;
    notifyListeners(); // ✅ Added
  }

  void addGroup(
    String name,
    String memberId,
    String color,
  ) {
    _groups.add(Group(
      id: DateTime.now().toString(),
      name: name,
      color: color,
      ownerId: memberId,
      memberIds: [memberId],
      shareLink:
          'https://projectnova.app/join/${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    ));
    notifyListeners(); // ✅ Added
  }

  void addGroupMembers(String groupId, List<String> memberIds) {
    final index = _groups.indexWhere((g) => g.id == groupId);

    if (index != -1) {
      final group = _groups[index];
      final updatedMemberIds = List<String>.from(group.memberIds ?? [])
        ..addAll(memberIds);

      _groups[index] = group.copyWith(memberIds: updatedMemberIds);
      notifyListeners(); // ✅ Added
    }
  }

  List<UserModel> getGroupMembers(String groupId) {
    final group = _groups.firstWhere((g) => g.id == groupId);
    final memberIds = group.memberIds;

    return memberIds.map((id) => getUserById(id)).toList();
  }

  UserModel getUserById(String id) {
    return _users.firstWhere((u) => u.id == id);
  }

  getUserName(String id) {}

  getTasksForUser(String id) {
    return _tasks.where((t) => t.assigneeIds.contains(id)).toList();
  }

  UserModel? loginUser(String email, String password) {
    print(_users);
    try {
      return _users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
    } on StateError {
      return null;
    }
  }

  List<UserModel> getAllUsers() {
    return _users;
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners(); // ✅ Added
  }

  void sendGroupInvite(
      String emailSender, String emailReciever, String groupId) {
    final user = getUserByEmail(emailReciever);
    final group = getGroupById(groupId);

    _notifications.add(Notifications(
        id: Random().toString(),
        userId: user!.id!,
        name: emailSender,
        content: group!.name,
        groupId: groupId,
        type: NotificationType.groupInvite,
        viewed: false,
        createdAt: DateTime.now()));
    notifyListeners(); // ✅ Added
  }

  UserModel? getUserByEmail(String email) {
    return _users.firstWhere((u) => u.email == email);
  }

  Group? getGroupById(String groupId) {
    return _groups.firstWhere((g) => g.id == groupId);
  }

  void leaveGroup(String groupID, String memberId) {
    final index = _groups.indexWhere((g) => g.id == groupID);

    if (index != -1) {
      final group = _groups[index];
      final updatedMemberIds = List<String>.from(group.memberIds ?? [])
        ..remove(memberId);

      _groups[index] = group.copyWith(memberIds: updatedMemberIds);
      notifyListeners(); // ✅ Added
    }
  }

  Future<void> updatedGroup(Group updatedGroup) async {
    final index = _groups.indexWhere((g) => g.id == updatedGroup.id);

    if (index != -1) {
      _groups[index] = updatedGroup;
      notifyListeners(); // ✅ Added
    }
  }
}
