class Parent {
  final String id;
  final String email;
  final String username;
  final String? fullName;
  final DateTime createdAt;
  final String password;

  Parent({
    required this.id,
    required this.email,
    required this.username,
    this.fullName,
    required this.createdAt,
    required this.password,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      username: json['username']?.toString() ??
          (json['email']?.toString().split('@').first ?? 'user'),
      fullName: json['full_name']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      password: json['password']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'full_name': fullName,
      'created_at': createdAt.toIso8601String(),
      'password': password,
    };
  }
}