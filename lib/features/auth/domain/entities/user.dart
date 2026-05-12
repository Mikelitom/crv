class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final bool isActive;
  final DateTime? lastLogin;
  final DateTime createdAt;
  final String scope;
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
    required this.scope,
    required this.role,
    required this.permissions,
  });

  bool get isVerified => scope != 'NONE' && scope.isNotEmpty;

  bool get isAdmin => role.contains('admin');

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    bool? isActive,
    DateTime? lastLogin,
    DateTime? createdAt,
    String? scope,
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
      scope: scope ?? this.scope,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
    );
  }
}