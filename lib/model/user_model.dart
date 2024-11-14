class User {
  final int userId;
  final String username;
  final String password;
  final String role; // Changed to non-nullable
  final String profilePhoto; // Changed to non-nullable

  User({
    required this.userId,
    required this.username,
    required this.password,
    this.role = 'user', // Default value for role
    this.profilePhoto = '', // Default value for profilePhoto
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      username: json['username'],
      password: json['password'],
      role: json['role'] ?? 'user', // Use default if null
      profilePhoto: json['profilePhoto'] ?? '', // Use default if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'password': password,
      'role': role,
      'profilePhoto': profilePhoto,
    };
  }
}
