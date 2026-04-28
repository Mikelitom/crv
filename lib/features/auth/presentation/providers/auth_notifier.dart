import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import 'package:crv_reprosisa/features/auth/presentation/di/auth_providers.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_state.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthNotifier extends Notifier<AuthState> {
  // Herramienta única para persistencia segura
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

  /// Proceso de inicio de sesión con persistencia selectiva
  Future<void> login(String email, String password, {bool rememberMe = false}) async {
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
        // --- PERSISTENCIA DEL TOKEN ---
        await _storage.write(key: 'token', value: user.id);

        // --- LÓGICA DE RECUÉRDAME ---
        // Usamos llaves fijas para que la nueva cuenta siempre sobrescriba a la anterior
        if (rememberMe) {
          await _storage.write(key: 'saved_email', value: email);
          await _storage.write(key: 'saved_password', value: password);
          await _storage.write(key: 'is_remembered', value: 'true');
        } else {
          // Si no se marca, limpiamos para que el formulario inicie vacío
          await _storage.delete(key: 'saved_email');
          await _storage.delete(key: 'saved_password');
          await _storage.write(key: 'is_remembered', value: 'false');
        }

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