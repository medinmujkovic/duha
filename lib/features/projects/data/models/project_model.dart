class ProjectModel {
  final String id;
  final String name;
  final String color;
  final List<String> memberIds;
  final String shareLink;
  final bool isShared;

  ProjectModel({
    required this.id,
    required this.name,
    required this.color,
    required this.memberIds,
    required this.shareLink,
    this.isShared = false,
  });
}