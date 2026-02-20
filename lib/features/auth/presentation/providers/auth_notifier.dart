import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository repository;

  @override
  AuthState build() {
    repository = ref.read(authRepositoryProvider);

    _checkAuth();
    return AuthState.initial();
  }

  Future<void> _checkAuth() async {
    try {
      final user = await repository.getMe();
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        user: null,
      );
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      await repository.login(email, password);
      final user = await repository.getMe();

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    await repository.logout();

    state = const AuthState(
      isLoading: false,
      isAuthenticated: false,
    );
  }
}