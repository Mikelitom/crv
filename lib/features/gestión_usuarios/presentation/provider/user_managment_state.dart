import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';

enum UserManagementStatus { initial, loading, success, error }

class UserManagementState {
  final List<User> users;
  final UserManagementStatus status;
  final Failure? error;
  final String? searchQuery;

  UserManagementState({
    required this.users,
    required this.status,
    this.error,
    this.searchQuery,
  });

  factory UserManagementState.initial() => UserManagementState(
        users: [],
        status: UserManagementStatus.initial,
      );

  UserManagementState copyWith({
    List<User>? users,
    UserManagementStatus? status,
    Failure? error,
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