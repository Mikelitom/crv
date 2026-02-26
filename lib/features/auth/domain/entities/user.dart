class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isActive;
  final DateTime? lastLogin;
  final DateTime createdAt;
  final List<String> role;
  final List<String> permissions;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.isActive,
    this.lastLogin,
    required this.createdAt,
    required this.role,
    required this.permissions,
  });
}

