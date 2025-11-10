import 'package:freezed_annotation/freezed_annotation.dart';

part 'section_model.freezed.dart';
part 'section_model.g.dart';

@freezed
class Section with _$Section {

  const factory Section({
    required String id,
    required String name,
    required int order,
  }) =_Section;

  factory Section.fromJson(Map<String, dynamic> json) => _$SectionFromJson(json);
}
