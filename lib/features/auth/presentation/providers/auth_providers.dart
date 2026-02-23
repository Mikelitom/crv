import 'package:crv_reprosisa/features/auth/domain/usecases/login_use_case.dart';
import 'package:crv_reprosisa/features/auth/presentation/providers/auth_data_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LoginUseCase(repository);
});
