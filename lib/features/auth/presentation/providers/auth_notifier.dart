import 'package:crv_reprosisa/features/auth/presentation/di/auth_providers.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_state.dart';
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
    state = state.copyWith(isLoading: true, error: null);

    final Either<Failure, AuthTokens> result = await ref.read(
      loginUseCaseProvider,
    )(email, password);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure);
      },
      (tokens) {
        state = state.copyWith(isLoading: false, tokens: tokens, error: null);
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    final result = await ref.read(logoutUseCaseProvider)();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure);
      },
      (_) {
        state = AuthState.initial();
      },
    );
  }
}
