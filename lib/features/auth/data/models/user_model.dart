import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user_model.dart';


class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;
  int level;
  int xp;
  int streak;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    this.level = 1,
    this.xp = 0,
    this.streak = 0,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    int? level,
    int? xp,
    int? streak,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
    );
  }
}