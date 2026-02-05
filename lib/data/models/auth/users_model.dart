class UsersModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String Scope;
  final String hashed_password;
  final DateTime? last_login;
  final int? failed_login_attempts;
  final DateTime? locked_until;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool is_active;

  UsersModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.Scope,
    required this.hashed_password,
    this.last_login,
    this.failed_login_attempts,
    this.locked_until,
    this.createdAt,
    this.updatedAt,
    required this.is_active,
  });
}