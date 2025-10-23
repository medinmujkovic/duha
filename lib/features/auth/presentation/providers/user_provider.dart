// lib/providers/user_provider.dart
// ignore_for_file: deprecated_member_use_from_same_package

import 'package:duha_app/features/auth/data/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
class User extends _$User {
  @override
  UserModel? build() {
    // Initially no user is logged in
    return null;
  }

  // Set user after login
  void setUser(UserModel user) {
    state = user;
  }

  // Clear user on logout
  void clearUser() {
    state = null;
  }

  // Update XP (auto-levels up)
  void updateXp(int xpToAdd) {
    if (state == null) return;
    
    final newXp = state!.xp + xpToAdd;
    const xpPerLevel = 1000;
    
    // Calculate new level
    final levelsGained = newXp ~/ xpPerLevel;
    final remainingXp = newXp % xpPerLevel;
    
    final newLevel = state!.level + levelsGained;
    
    state = state!.copyWith(
      xp: remainingXp,
      level: newLevel,
    );
    
    // TODO: Save to Firestore
    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(state!.id)
    //     .update({
    //   'xp': remainingXp,
    //   'level': newLevel,
    // });
  }

  // Update level directly
  void updateLevel(int level) {
    if (state == null) return;
    state = state!.copyWith(level: level);
  }

  // Update streak
  void updateStreak(int streak) {
    if (state == null) return;
    state = state!.copyWith(streak: streak);
  }

  // Increment streak (daily login)
  void incrementStreak() {
    if (state == null) return;
    state = state!.copyWith(streak: state!.streak + 1);
  }

  // Reset streak
  void resetStreak() {
    if (state == null) return;
    state = state!.copyWith(streak: 0);
  }

  // Update profile
  void updateProfile({
    String? name,
    String? email,
    String? avatar,
  }) {
    if (state == null) return;
    state = state!.copyWith(
      name: name,
      email: email,
      avatar: avatar,
    );
  }
}

// Convenience providers
@riverpod
bool isLoggedIn(IsLoggedInRef ref) {
  return ref.watch(userProvider) != null;
}

@riverpod
int userLevel(UserLevelRef ref) {
  return ref.watch(userProvider)?.level ?? 1;
}

@riverpod
int userXp(UserXpRef ref) {
  return ref.watch(userProvider)?.xp ?? 0;
}

@riverpod
int userStreak(UserStreakRef ref) {
  return ref.watch(userProvider)?.streak ?? 0;
}

@riverpod
String userName(UserNameRef ref) {
  return ref.watch(userProvider)?.name ?? 'Guest';
}

@riverpod
double xpProgress(XpProgressRef ref) {
  final user = ref.watch(userProvider);
  if (user == null) return 0.0;
  
  const xpPerLevel = 1000;
  return (user.xp % xpPerLevel) / xpPerLevel;
}