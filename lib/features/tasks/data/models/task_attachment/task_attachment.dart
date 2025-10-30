import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_attachment.freezed.dart';
part 'task_attachment.g.dart';

@freezed
class TaskAttachment with _$TaskAttachment {
  const factory TaskAttachment({
    required String id,
    required String name,
    required String type, // 'image', 'document'
    required String url,
  }) = _TaskAttachment;

  factory TaskAttachment.fromJson(Map<String, dynamic> json) =>
      _$TaskAttachmentFromJson(json);
}
