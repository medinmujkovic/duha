import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart'; // Generated file

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

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  UserModel? build() {
    // Initially no user is logged in
    return null;
  }

  void setUser(UserModel user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }

  void updateXp(int xp) {
    if (state == null) return;
    state = state!.copyWith(xp: state!.xp + xp);
  }

  void updateLevel(int level) {
    if (state == null) return;
    state = state!.copyWith(level: level);
  }

  void updateStreak(int streak) {
    if (state == null) return;
    state = state!.copyWith(streak: streak);
  }
}
