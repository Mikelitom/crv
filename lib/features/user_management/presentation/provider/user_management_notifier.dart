import 'package:crv_reprosisa/features/user_management/presentation/provider/user_management_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/usecases/get_users_use_cases.dart';

import 'user_management_state.dart';


class UserManagementNotifier extends Notifier<UserManagementState> {
  late final GetUsers _getUsers;

  @override
  UserManagementState build() {
    _getUsers = ref.read(getUsersUseCaseProvider);
    return const UserManagementState();
  }

  Future<void> getUsers() async {
    state = state.copyWith(status: UserManagementStatus.loading);
    final result = await _getUsers();

    result.fold(
      (failure) => state = state.copyWith(status: UserManagementStatus.error, error: failure.message),
      (users) => state = state.copyWith(status: UserManagementStatus.success, users: users),
    );
  }

  Future<void> toggleUserStatus(String userId, bool isActive) async {
    state = state.copyWith(status: UserManagementStatus.loading);
    final result = isActive 
        ? await ref.read(activateUserUseCaseProvider).call(userId) 
        : await ref.read(deactivateUserUseCaseProvider).call(userId);

    result.fold(
      (failure) => state = state.copyWith(status: UserManagementStatus.error, error: failure.message),
      (_) {
        final updatedUsers = state.users.map<User>((u) {
          if (u.id == userId) return u.copyWith(isActive: isActive);
          return u;
        }).toList();
        state = state.copyWith(users: updatedUsers, status: UserManagementStatus.success);
      },
    );
  }

  Future<void> updateUserField({
    required String userId,
    List<String>? role,
    String? scope,
  }) async {
    final result = await ref.read(updateUserUseCaseProvider).call(
      userId: userId,
      role: role,
      scope: scope,
    );

    result.fold(
      (failure) => state = state.copyWith(status: UserManagementStatus.error, error: failure.message),
      (updatedUser) {
        // CORRECCIÓN DE TIPADO: map<User> evita el error de List<dynamic>
        final updatedUsers = state.users.map<User>((u) {
          return u.id == userId ? updatedUser : u;
        }).toList();
        
        state = state.copyWith(users: updatedUsers, status: UserManagementStatus.success);
      },
    );
  }
}