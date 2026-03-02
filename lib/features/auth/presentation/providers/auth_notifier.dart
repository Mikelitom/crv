import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import 'package:crv_reprosisa/features/auth/presentation/di/auth_providers.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_state.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import '../../domain/entities/auth_tokens.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState.initial();
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    final Either<Failure, User> result = await ref.read(loginUseCaseProvider)(
      email,
      password,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          error: failure,
        );
      },
      (user) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          error: null,
        );
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    final result = await ref.read(logoutUseCaseProvider)();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          error: failure,
        );
      },
      (_) {
        state = AuthState.initial();
      },
    );
  }

  Future<void> getMe() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await ref.read(getMeUseCaseProvider)();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          error: failure,
        );
      },
      (user) {
        state = state.copyWith(user: user);
      },
    );
  }
}
