// lib/providers/user_provider.dart
import 'package:duha_app/features/auth/data/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
class User extends _$UserNotifier {
  @override
  UserModel? build() {
    // No user logged in by default
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
