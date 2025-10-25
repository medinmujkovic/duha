import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
  required String? id,
  required String? name,
  required String? email,
  required String? password,
  required String? avatar,
  required int level,
  required int  xp,
  required int streak,
}) = _UserModel;

  // Add this constructor for computed properties
  const UserModel._();

  // Computed property
  bool get isAuthenticated => id != null;

  // Factory for empty/unauthenticated user
  factory UserModel.empty() => const UserModel(
        id: null,
        email: null,
        name: null,
        avatar: null, level: 0, xp: 0, streak: 0,
        password: null
      );

  factory UserModel.fromJson(Map<String, dynamic> json) =>_$UserModelFromJson(json);

}