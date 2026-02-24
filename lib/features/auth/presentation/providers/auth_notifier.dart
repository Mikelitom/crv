import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import '../../domain/entities/auth_tokens.dart';
import 'auth_providers.dart';

class AuthNotifier extends AsyncNotifier<AuthTokens?> {
  @override
  AuthTokens? build() => null; // estado inicial vacío

  Future<void> login(String email, String password) async {
    // Indica que la operación está cargando
    state = const AsyncLoading();

    // Llamamos al use case directamente desde ref
    final Either<Failure, AuthTokens> result =
        await ref.read(loginUseCaseProvider)(email, password);

    // Hacemos fold: izquierda = failure, derecha = éxito
    result.fold(
      (failure) {
        // Guardamos el error completo
        state = AsyncError(failure, StackTrace.current);
      },
      (tokens) {
        // Guardamos los tokens en el estado
        state = AsyncData(tokens);
      },
    );
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    try {
      // Supongamos que tienes un use case de logout que devuelve Either<Failure, Unit>
      final result = await ref.read(logoutUseCaseProvider)();

      result.fold(
        (failure) => state = AsyncError(failure, StackTrace.current),
        (_) => state = const AsyncData(null), // Logout = estado vacío
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
