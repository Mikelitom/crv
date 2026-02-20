import '../../domain/entities/user.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final User? user;

  AuthState({
    required this.isLoading,
    required this.isAuthenticated,
    this.user,
  });

  factory AuthState.initial() =>
      AuthState(isLoading: true, isAuthenticated: false);
}