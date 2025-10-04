import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final String groupId;
  final String taskId;
  const TaskDetailScreen(
      {super.key, required this.groupId, required this.taskId});

  String _periodKey(Map<String, dynamic> repeat) {
    final type = repeat['type'] ?? 'none';
    final now = DateTime.now();
    if (type == 'daily')
      return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    if (type == 'weekly') {
      final weekOfYear = int.parse(ISOWeekNumber(now));
      return '${now.year}-W$weekOfYear';
    }
    if (type == 'monthly')
      return '${now.year}-${now.month.toString().padLeft(2, '0')}';
    return 'single';
  }

  @override
  Widget build(BuildContext context) {
    final taskRef = FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('tasks')
        .doc(taskId);
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: taskRef.snapshots(),
      builder: (context, snap) {
        if (!snap.hasData)
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        final t = snap.data!.data() as Map<String, dynamic>;
        final hasSubtasks = t['hasSubtasks'] ?? false;
        final repeat = (t['repeat'] ?? {}) as Map<String, dynamic>;

        return Scaffold(
          appBar: AppBar(title: Text(t['title'] ?? 'Task')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (t['description'] != null) Text(t['description']),
                const SizedBox(height: 16),
                if (hasSubtasks)
                  _SubtasksSection(groupId: groupId, taskId: taskId, uid: uid),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Mark as done'),
                    onPressed: () async {
                      final periodKey = _periodKey(repeat);
                      await taskRef.collection('completions').add({
                        'userId': uid,
                        'completedAt': DateTime.now(),
                        'periodKey': periodKey,
                      });
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SubtasksSection extends StatelessWidget {
  final String groupId;
  final String taskId;
  final String uid;
  const _SubtasksSection(
      {required this.groupId, required this.taskId, required this.uid});

  @override
  Widget build(BuildContext context) {
    final subtasksRef = FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('tasks')
        .doc(taskId)
        .collection('subtasks')
        .orderBy('order');
    final progressRef = FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('tasks')
        .doc(taskId)
        .collection('subtaskProgress')
        .doc(uid);

    return StreamBuilder<QuerySnapshot>(
      stream: subtasksRef.snapshots(),
      builder: (context, s1) {
        if (!s1.hasData)
          return const Center(child: CircularProgressIndicator());
        final subs = s1.data!.docs;
        return StreamBuilder<DocumentSnapshot>(
          stream: progressRef.snapshots(),
          builder: (context, s2) {
            final prog = (s2.data?.data() as Map<String, dynamic>?) ?? {};
            final total = subs.length;
            final done =
                subs.where((d) => (prog[d.id] ?? false) == true).length;
            final pct = total == 0 ? 0.0 : done / total;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(value: pct),
                const SizedBox(height: 8),
                Text('Progress: ${done}/${total}'),
                const SizedBox(height: 8),
                ...subs.map((doc) {
                  final d = doc.data() as Map<String, dynamic>;
                  final checked = (prog[doc.id] ?? false) == true;
                  return CheckboxListTile(
                    title: Text(d['title'] ?? ''),
                    value: checked,
                    onChanged: (v) async {
                      await progressRef
                          .set({doc.id: v == true}, SetOptions(merge: true));
                    },
                  );
                })
              ],
            );
          },
        );
      },
    );
  }
}

String ISOWeekNumber(DateTime date) {
// Simple ISO week number calc
  final thursday = date.add(Duration(days: 3 - ((date.weekday + 6) % 7)));
  final firstThursday = DateTime(thursday.year, 1, 4);
  final diff = thursday.difference(firstThursday);
  final week = 1 + (diff.inDays / 7).floor();
  return week.toString().padLeft(2, '0');
}
