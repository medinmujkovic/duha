import 'package:freezed_annotation/freezed_annotation.dart';

part 'subtask_model.freezed.dart';
part 'subtask_model.g.dart';

@freezed
class Subtask with _$Subtask {
  const factory Subtask({
    required String id,
    required String title,
    @Default(false) bool isCompleted,
  }) = _Subtask;

  factory Subtask.fromJson(Map<String, dynamic> json) => _$SubtaskFromJson(json);
}
