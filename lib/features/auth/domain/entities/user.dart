class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final bool isActive;
  final DateTime? lastLogin;
  final DateTime createdAt;
  final List<String> role;
  final List<String> permissions;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.isActive,
    this.lastLogin,
    required this.createdAt,
    required this.role,
    required this.permissions,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    bool? isActive,
    DateTime? lastLogin,
    DateTime? createdAt,
    List<String>? role,
    List<String>? permissions,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
    );
  }
}
