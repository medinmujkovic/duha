class Project {
  final String id;
  final String name;
  final String color;
  final List<String> memberIds;
  final String shareLink;
  final bool isShared;

  Project({
    required this.id,
    required this.name,
    required this.color,
    required this.memberIds,
    required this.shareLink,
    this.isShared = false,
  });
}