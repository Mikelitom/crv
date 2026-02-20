import 'package:crv_reprosisa/features/auth/domain/usecases/login_use_case.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';

class AuthNotifier extends AsyncNotifier<User?> {
  late final LoginUseCase _loginUseCase;

  @override
  Future<User?> build() async {
    _loginUseCase = ref.read(loginUseCaseProvider);
    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    final result = await _loginUseCase(email, password);

    result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
      },
      (user) {
        state = AsyncData(user);
      },
    );
  }
}
