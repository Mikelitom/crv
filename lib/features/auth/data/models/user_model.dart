import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    required super.isActive,
    required super.createdAt,
    required super.role,
    required super.scope,
    required super.permissions,
    super.lastLogin,
  });

  // Getters para facilitar la lógica de bloqueo en la UI
  bool get isVerified => scope != 'none' && scope.isNotEmpty;
  bool get isAdmin => role.contains('admin');

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      isActive: json['is_active'],
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      role: json['roles'] != null ? List<String>.from(json['roles']) : [],
      scope: json['scope'] ?? 'none',
      permissions: json['permissions'] != null ? List<String>.from(json['permissions']) : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "is_active": isActive,
        "last_login": lastLogin?.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "roles": role,
        "scope": scope,
        "permissions": permissions,
      };
}