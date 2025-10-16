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
}