import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:duha_app/features/auth/data/models/user_model.dart';
import 'package:duha_app/features/auth/presentation/providers/user_provider.dart';
import 'package:duha_app/features/groups/data/models/group_model.dart';
import 'package:duha_app/features/notifications/data/models/notification_enum.dart';
import 'package:duha_app/features/notifications/data/models/notifications_model.dart';
import 'package:duha_app/features/projects/data/models/section_model/section_model.dart';
import 'package:duha_app/features/tasks/data/enums/task_enum.dart';
import 'package:duha_app/features/tasks/data/models/task/task_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class DataService extends ChangeNotifier {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // Collections
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _groupsCollection => _firestore.collection('groups');
  CollectionReference get _tasksCollection => _firestore.collection('tasks');
  CollectionReference get _sectionsCollection =>
      _firestore.collection('sections');
  CollectionReference get _notificationsCollection =>
      _firestore.collection('notifications');

  // ==================== USER METHODS ====================

  Future<UserModel> createUser({
    required String name,
    required String email,
    required String password,
    required String avatar,
  }) async {
    final cred = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    final uid = cred.user!.uid;

    final user = UserModel(
      id: uid, // IMPORTANT: use Firebase uid
      name: name,
      email: email,
      avatar: avatar,
      xp: 0,
      level: 1,
      streak: 0,
      password: '', // don’t store password
    );

    await _usersCollection.doc(uid).set(user.toJson());
    notifyListeners();
    return user;
  }

  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final cred = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    final uid = cred.user!.uid;

    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists) return null;

    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<UserModel?> getUserById(String id) async {
    try {
      final doc = await _usersCollection.doc(id).get();
      if (!doc.exists) return null;
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _usersCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      return UserModel.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error getting user by email: $e');
      return null;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final querySnapshot = await _usersCollection.get();
      return querySnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  Stream<List<UserModel>> getUserFriendsStream(String userId) {
    return _groupsCollection
        .where('memberIds', arrayContains: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      Set<String> memberIds = {};

      for (var doc in snapshot.docs) {
        final group = Group.fromJson(doc.data() as Map<String, dynamic>);
        memberIds.addAll(group.memberIds);
      }

      memberIds.remove(userId); // Remove self

      List<UserModel> friends = [];
      for (String id in memberIds) {
        final user = await getUserById(id);
        if (user != null) friends.add(user);
      }

      return friends;
    });
  }

  // ==================== TASK METHODS ====================

  Future<void> addTask({
    required String title,
    String description = '',
    Priority priority = Priority.medium,
    DateTime? deadline,
    String? repeat,
    String? sectionId,
    String? groupId,
    TaskType? taskType,
    required List<String> assigneeIds,
  }) async {
    final task = Task(
      id: _uuid.v4(),
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
    );

    await _tasksCollection.doc(task.id).set(task.toJson());
    notifyListeners();
  }

  Future<void> updateTask({
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
  }) async {
    try {
      final doc = await _tasksCollection.doc(id).get();
      if (!doc.exists) throw Exception('Task with id=$id not found');

      final current = Task.fromJson(doc.data() as Map<String, dynamic>);

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

      await _tasksCollection.doc(id).update(updated.toJson());
      notifyListeners();
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
    notifyListeners();
  }

  Future<void> toggleTaskCompletion({
    required String taskId,
    required String userId,
    required WidgetRef ref,
  }) async {
    try {
      final doc = await _tasksCollection.doc(taskId).get();
      if (!doc.exists) return;

      final task = Task.fromJson(doc.data() as Map<String, dynamic>);
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

        // Update user XP
        ref.read(userProvider.notifier).updateUser((u) {
          if (u == null) return u;

          int newXp = u.xp + updatedTask.xpReward;
          int newLevel = u.level;

          while (newXp >= 3000) {
            newLevel += 1;
            newXp -= 3000;
          }

          // Update user in Firestore
          _usersCollection.doc(u.id).update({'xp': newXp, 'level': newLevel});

          return u.copyWith(xp: newXp, level: newLevel);
        });
      } else if (!updatedTask.isCompleted) {
        updatedTask = updatedTask.copyWith(completedAt: null);
      }

      await _tasksCollection.doc(taskId).update(updatedTask.toJson());
      notifyListeners();
    } catch (e) {
      print('Error toggling task completion: $e');
    }
  }

  Stream<List<Task>> getTasksStream() {
    return _tasksCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Task.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<List<Task>> getTasksForGroupStream(String groupId) {
    return _tasksCollection
        .where('groupId', isEqualTo: groupId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Task.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<List<Task>> getTasksForUserStream(String userId) {
    return _tasksCollection
        .where('assigneeIds', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Task.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

Future<List<Task>> getCompletedTasks(String uid) async {
  final snapshot = await _tasksCollection
      .where('completedByIds', arrayContains: uid)
      .get();

  return snapshot.docs
      .map((d) => Task.fromJson(d.data() as Map<String, dynamic>))
      .toList();
}

  // ==================== GROUP METHODS ====================

  Future<void> addGroup(
    String name,
    String memberId,
    String color,
  ) async {
    final group = Group(
      id: _uuid.v4(),
      name: name,
      color: color,
      ownerId: memberId,
      memberIds: [memberId],
      shareLink:
          'https://projectnova.app/join/${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );

    await _groupsCollection.doc(group.id).set(group.toJson());
    notifyListeners();
  }

  Future<void> updateGroup(Group updatedGroup) async {
    await _groupsCollection.doc(updatedGroup.id).update(updatedGroup.toJson());
    notifyListeners();
  }

  Future<void> addGroupMembers(String groupId, List<String> memberIds) async {
    await _groupsCollection.doc(groupId).update({
      'memberIds': FieldValue.arrayUnion(memberIds),
    });
    notifyListeners();
  }

  Future<void> leaveGroup(String groupId, String memberId) async {
    await _groupsCollection.doc(groupId).update({
      'memberIds': FieldValue.arrayRemove([memberId]),
    });
    notifyListeners();
  }

  Stream<List<Group>> getUserGroupsStream(String userId) {
    return _groupsCollection
        .where('memberIds', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Group.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<Group?> getGroupById(String groupId) async {
    try {
      final doc = await _groupsCollection.doc(groupId).get();
      if (!doc.exists) return null;
      return Group.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error getting group: $e');
      return null;
    }
  }

  Future<List<UserModel>> getGroupMembers(String groupId) async {
    try {
      final group = await getGroupById(groupId);
      if (group == null) return [];

      List<UserModel> members = [];
      for (String memberId in group.memberIds) {
        final user = await getUserById(memberId);
        if (user != null) members.add(user);
      }

      return members;
    } catch (e) {
      print('Error getting group members: $e');
      return [];
    }
  }

  // ==================== SECTION METHODS ====================

  Future<void> addSection(String name, String userId) async {
    final section = Section(
      id: _uuid.v4(),
      name: name,
      order: 0, // You might want to calculate this
    );

    await _sectionsCollection.doc(section.id).set({
      ...section.toJson(),
      'userId': userId,
    });
    notifyListeners();
  }

  Future<void> deleteSection(String sectionId) async {
    await _sectionsCollection.doc(sectionId).delete();
    notifyListeners();
  }

  Future<void> renameSection(String sectionId, String newName) async {
    await _sectionsCollection.doc(sectionId).update({'name': newName});
    notifyListeners();
  }

  Stream<List<Section>> getSectionsStream(String userId) {
    return _sectionsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('order')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Section.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // ==================== NOTIFICATION METHODS ====================

  Future<void> sendGroupInvite(
      String emailSender, String emailReceiver, String groupId) async {
    try {
      final user = await getUserByEmail(emailReceiver);
      final group = await getGroupById(groupId);

      if (user == null || group == null) return;

      final notification = Notifications(
        id: _uuid.v4(),
        userId: user.id!,
        name: emailSender,
        content: group.name,
        groupId: groupId,
        type: NotificationType.groupInvite,
        viewed: false,
        createdAt: DateTime.now(),
      );

      await _notificationsCollection
          .doc(notification.id)
          .set(notification.toJson());
      notifyListeners();
    } catch (e) {
      print('Error sending group invite: $e');
    }
  }

  Future<void> deleteNotification(String id) async {
    await _notificationsCollection.doc(id).delete();
    notifyListeners();
  }

  Stream<List<Notifications>> getNotificationsStream(String userId) {
    return _notificationsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              Notifications.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> markNotificationAsViewed(String notificationId) async {
    await _notificationsCollection.doc(notificationId).update({'viewed': true});
    notifyListeners();
  }
}
