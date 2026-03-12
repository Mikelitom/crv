import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/provider/user_managment_state.dart';
import '../../presentation/provider/user_managment_use_case.dart';

class UserManagementNotifier extends Notifier<UserManagementState> {
  @override
  UserManagementState build() {
    
    Future.microtask(() => getUsers());
    return UserManagementState.initial();
  }

  Future<void> getUsers() async {
    state = state.copyWith(status: UserManagementStatus.loading);

    final result = await ref.read(getUsersUseCaseProvider).call();

    result.fold(
      (failure) => state = state.copyWith(
        status: UserManagementStatus.error,
        error: failure,
      ),
      (users) => state = state.copyWith(
        status: UserManagementStatus.success,
        users: users,
      ),
    );
  }

  Future<void> toggleUserStatus(String userId, bool isActive) async {
   
    final result = await ref.read(updateUserUseCaseProvider).call(
      userId: userId,
      isActive: isActive,
    );

    result.fold(
      (failure) => state = state.copyWith(error: failure),
      (updatedUser) {
        // Actualizamos el usuario específico en la lista actual
        final newUsers = state.users.map((u) {
          return u.id == userId ? updatedUser : u;
        }).toList();
        state = state.copyWith(users: newUsers);
      },
    );
  }
}


final userManagementProvider =
    NotifierProvider<UserManagementNotifier, UserManagementState>(
  UserManagementNotifier.new,
);