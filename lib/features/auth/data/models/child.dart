class Child {
  final String id;
  final String parentId;
  final String username;
  final String password;
  final int age;
  final String gender;
  final DateTime createdAt;
  final String? avatarUrl;

  Child({
    required this.id,
    required this.parentId,
    required this.username,
    required this.password,
    required this.age,
    required this.gender,
    required this.createdAt,
    this.avatarUrl,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      parentId: json['parent_id'],
      username: json['username'],
      password: json['password'],
      age: json['age'],
      gender: json['gender'],
      createdAt: DateTime.parse(json['created_at']),
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'username': username,
      'password': password,
      'age': age,
      'gender': gender,
      'created_at': createdAt.toIso8601String(),
      'avatar_url': avatarUrl,
    };
  }
}