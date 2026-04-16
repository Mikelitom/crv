import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import 'package:crv_reprosisa/features/auth/presentation/di/auth_providers.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_state.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthNotifier extends Notifier<AuthState> {
  // Herramienta para guardar el token físicamente en el celular
  final _storage = const FlutterSecureStorage();

  @override
  AuthState build() {
    // Al iniciar el provider, intentamos recuperar la sesión
    Future.microtask(() => checkAuthStatus());
    return AuthState.initial();
  }

  /// Revisa si hay un token guardado para entrar directo a la app
  Future<void> checkAuthStatus() async {
    final token = await _storage.read(key: 'token');
    
    // Si no hay token guardado, no hacemos nada (el usuario debe loguearse)
    if (token == null) return;

    // Si hay token, ejecutamos getMe para validar si sigue vigente en el servidor
    await getMe();
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
      (user) async {
        // --- PERSISTENCIA ---
        // Guardamos el ID o Token para que la sesión sea permanente
        await _storage.write(key: 'token', value: user.id);

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

    // Borramos el token físico al cerrar sesión voluntariamente
    await _storage.delete(key: 'token');

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
      (failure) async {
        // Si getMe falla (token inválido o expirado), limpiamos el storage
        await _storage.delete(key: 'token');
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

  Future<Either<Failure, Unit>> requestPasswordReset(String email) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    final result = await ref.read(authRepositoryProvider).requestPasswordReset(email);
    return result.fold(
      (failure) {
        state = state.copyWith(status: AuthStatus.unauthenticated, error: failure);
        return Left(failure);
      },
      (unitValue) {
        state = state.copyWith(status: AuthStatus.initial, error: null);
        return Right(unitValue);
      },
    );
  }

  Future<Either<Failure, Unit>> confirmPasswordReset({
    required String token,
    required String newPassword,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    final result = await ref.read(authRepositoryProvider).confirmPasswordReset(
          token: token,
          newPassword: newPassword,
        );
    return result.fold(
      (failure) {
        state = state.copyWith(status: AuthStatus.unauthenticated, error: failure);
        return Left(failure);
      },
      (unitValue) {
        state = state.copyWith(status: AuthStatus.initial, error: null);
        return Right(unitValue);
      },
    );
  }

  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    final Either<Failure, User> result = await ref.read(
      registerUseCaseProvider,
    )(name: name, phone: phone, email: email, password: password);
    result.fold(
      (failure) => state = state.copyWith(status: AuthStatus.unauthenticated, error: failure),
      (user) => state = state.copyWith(status: AuthStatus.authenticated, user: user, error: null),
    );
  }
}