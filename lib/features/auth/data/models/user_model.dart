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
      role: List<String>.from(json['roles']),
      scope: json['scope'],
      permissions: List<String>.from(json['permissions']),
    );
  }
}
