import 'package:duha_app/core/util/json_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_model.freezed.dart';
part 'token_model.g.dart';

@freezed
class Token with _$Token {
  const factory Token({
    required String id,
    required String userId,
    required String token,
    @TimestampConverter() required DateTime createdAt,
  }) = _Token;

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
}
