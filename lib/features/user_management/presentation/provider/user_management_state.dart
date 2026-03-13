import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';

enum UserManagementStatus { initial, loading, success, error }

class UserManagementState {
  final List<User> users;
  final UserManagementStatus status;
  final String? error;
  final String? searchQuery;

  const UserManagementState({
    this.status = UserManagementStatus.initial,
    this.users = const [],
    this.error,
    this.searchQuery,
  });

  factory UserManagementState.initial() =>
      UserManagementState(users: [], status: UserManagementStatus.initial);

  UserManagementState copyWith({
    List<User>? users,
    UserManagementStatus? status,
    String? error,
    String? searchQuery,
  }) {
    return UserManagementState(
      users: users ?? this.users,
      status: status ?? this.status,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
