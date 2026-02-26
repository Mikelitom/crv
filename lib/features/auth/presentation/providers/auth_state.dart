import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/auth_tokens.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';

class AuthState {
  final bool isLoading;
  final AuthTokens? tokens;
  final Failure? error;
  final User? user;

  const AuthState({
    required this.isLoading,
    this.tokens,
    this.error,
    this.user,
  });

  factory AuthState.initial() {
    return const AuthState(
      isLoading: false,
      tokens: null,
      error: null,
      user: null,
    );
  }

  bool get isAuthenticated => tokens != null;

  AuthState copyWith({
    bool? isLoading,
    AuthTokens? tokens,
    User? user,
    Failure? error,
    bool clearTokens = false,
    bool clearUser = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      tokens: clearTokens ? null : (tokens ?? this.tokens),
      user: clearUser ? null : (user ?? this.user),
      error: error,
    );
  }
}
