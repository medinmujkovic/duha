import 'package:duha_app/core/util/json_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'group_model.freezed.dart';
part 'group_model.g.dart';

@freezed
class Group with _$Group {
  const factory Group({
    required String id,
    required String name,
    required String ownerId,
    required List<String> memberIds,
    @TimestampConverter() required DateTime createdAt,
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
