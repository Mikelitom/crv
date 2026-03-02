import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/auth_tokens.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_status.dart';

class AuthState {
  final AuthStatus status;
  final Failure? error;
  final User? user;

  const AuthState({required this.status, this.error, this.user});

  const AuthState.initial()
    : status = AuthStatus.initial,
      user = null,
      error = null;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({AuthStatus? status, User? user, Failure? error}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }
}
