import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../tasks/task_detail_screen.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final q = FirebaseFirestore.instance
        .collection('groups')
        .where('memberIds', arrayContains: uid)
        .orderBy('createdAt', descending: true);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Groups')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final nameController = TextEditingController();
          await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: const Text('Create group'),
                    content: TextField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(labelText: 'Group name')),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel')),
                      FilledButton(
                          onPressed: () async {
                            final name = nameController.text.trim();
                            if (name.isEmpty) return;
                            final now = DateTime.now();
                            final uid = FirebaseAuth.instance.currentUser!.uid;
                            final ref = await FirebaseFirestore.instance
                                .collection('groups')
                                .add({
                              'name': name,
                              'memberIds': [uid],
                              'createdBy': uid,
                              'createdAt': now,
                            });
                            Navigator.pop(ctx);
// open the new group
// ignore: use_build_context_synchronously
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        GroupDetailScreen(groupId: ref.id)));
                          },
                          child: const Text('Create')),
                    ],
                  ));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: q.snapshots(),
        builder: (context, snap) {
          if (!snap.hasData)
            return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          if (docs.isEmpty)
            return const Center(child: Text('No groups yet. Tap + to create.'));
          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final d = docs[i];
              return ListTile(
                title: Text(d['name']),
                subtitle: const Text('Tap to open'),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => GroupDetailScreen(groupId: d.id))),
              );
            },
          );
        },
      ),
    );
  }
}

class GroupDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasksRef = FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('tasks')
        .where('isArchived', isEqualTo: false)
        .orderBy('createdAt', descending: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group'),
        actions: [
          IconButton(
              icon: const Icon(Icons.leaderboard),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    builder: (_) => ScoreboardSheet(groupId: groupId));
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => TaskEditor(groupId: groupId)));
        },
        child: const Icon(Icons.add_task),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: tasksRef.snapshots(),
        builder: (context, snap) {
          if (!snap.hasData)
            return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          if (docs.isEmpty)
            return const Center(child: Text('No tasks yet. Tap + to add.'));
          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final t = docs[i].data() as Map<String, dynamic>;
              final taskId = docs[i].id;
              final isIndividual = (t['type'] ?? 'individual') == 'individual';
              return ListTile(
                title: Text(t['title'] as String),
                subtitle: Text(isIndividual ? 'Individual' : 'Shared'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TaskDetailScreen(
                            groupId: groupId, taskId: taskId))),
              );
            },
          );
        },
      ),
    );
  }
}

class ScoreboardSheet extends StatelessWidget {
  final String groupId;
  const ScoreboardSheet({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final q = FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('members')
        .orderBy('points', descending: true)
        .limit(50);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: q.snapshots(),
          builder: (context, snap) {
            if (!snap.hasData)
              return const Center(child: CircularProgressIndicator());
            final docs = snap.data!.docs;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Scoreboard',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, i) {
                      final d = docs[i].data() as Map<String, dynamic>;
                      return ListTile(
                        leading: CircleAvatar(child: Text('${i + 1}')),
                        title: Text(d['displayName'] ?? 'Member'),
                        trailing: Text('${d['points'] ?? 0} pts'),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
