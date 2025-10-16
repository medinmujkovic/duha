class TaskAttachment {
  final String id;
  final String name;
  final String type; // 'image', 'document'
  final String url;

  TaskAttachment({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
  });
}