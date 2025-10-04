import 'package:cloud_firestore/cloud_firestore.dart';


enum TaskType { shared, individual }
enum RepeatType { none, daily, weekly, monthly, rrule }


class TaskModel {
final String id;
final String groupId;
final String title;
final String? description;
final TaskType type;
final RepeatType repeatType;
final String? rrule; // optional
final bool hasSubtasks;
final int points;
final DateTime? dueDate;
final String createdBy;
final DateTime createdAt;
final bool isArchived;


TaskModel({
required this.id,
required this.groupId,
required this.title,
this.description,
required this.type,
required this.repeatType,
this.rrule,
required this.hasSubtasks,
required this.points,
this.dueDate,
required this.createdBy,
required this.createdAt,
this.isArchived = false,
});


factory TaskModel.fromDoc(DocumentSnapshot doc) {
final d = doc.data() as Map<String, dynamic>;
return TaskModel(
id: doc.id,
groupId: doc.reference.parent.parent!.id,
title: d['title'],
description: d['description'],
type: d['type'] == 'shared' ? TaskType.shared : TaskType.individual,
repeatType: RepeatType.values.firstWhere((e) => e.name == (d['repeat']?['type'] ?? 'none')),
rrule: d['repeat']?['rrule'],
hasSubtasks: d['hasSubtasks'] ?? false,
points: (d['points'] ?? 10) as int,
dueDate: (d['dueDate'] as Timestamp?)?.toDate(),
createdBy: d['createdBy'],
createdAt: (d['createdAt'] as Timestamp).toDate(),
isArchived: d['isArchived'] ?? false,
);
}
}