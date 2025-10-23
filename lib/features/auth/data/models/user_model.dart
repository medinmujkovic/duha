import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart'

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
  required String? id,
  required String? name,
  required String? email,
  required String? avatar,
  int level,
  int xp,
  int streak,
}) = _UserModel;

  // Add this constructor for computed properties
  const UserModel._();

  // Computed property
  bool get isAuthenticated => userId != null;

  // Factory for empty/unauthenticated user
  factory UserModel.empty() => const UserModel(
        id: null,
        email: null,
        name: null,
        avatar: null,
      );

}