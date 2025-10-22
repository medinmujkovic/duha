

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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'level': level,
      'xp': xp,
      'streak': streak,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      level: json['level'] as int? ?? 1,
      xp: json['xp'] as int? ?? 0,
      streak: json['streak'] as int? ?? 0,
    );
  }
}