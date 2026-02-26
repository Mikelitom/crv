import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/core/storage/secure_storage_provider.dart';
import 'package:crv_reprosisa/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:crv_reprosisa/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:crv_reprosisa/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:crv_reprosisa/features/auth/data/repositories/token_repository_impl.dart';
import 'package:crv_reprosisa/features/auth/domain/repositories/auth_repository.dart';
import 'package:crv_reprosisa/features/auth/domain/repositories/token_repository.dart';
import 'package:crv_reprosisa/features/auth/domain/usecases/login_use_case.dart';
import 'package:crv_reprosisa/features/auth/domain/usecases/logout_use_case.dart';
import 'package:crv_reprosisa/features/auth/domain/usecases/change_password_use_case.dart';
import 'package:crv_reprosisa/features/auth/domain/usecases/get_me_use_case.dart';
import 'package:crv_reprosisa/features/auth/domain/usecases/save_tokens_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// DataSource
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.read(dioProvider));
});

// Repositories
final tokenRepositoryProvider = Provider<TokenRepository>((ref) {
  final storage = ref.read(secureStorageProvider);
  return TokenRepositoryImpl(storage);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remote: ref.read(authRemoteDataSourceProvider),
    tokenRepository: ref.read(tokenRepositoryProvider),
  );
});

// UseCases
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LoginUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LogoutUseCase(repository);
});

final changePasswordUseCaseProvider = Provider<ChangePasswordUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return ChangePasswordUseCase(repository);
});

final getMeUseCaseProvider = Provider<GetMeUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return GetMeUseCase(repository);
});

final saveTokensUseCaseProvider = Provider<SaveTokensUseCase>((ref) {
  final repository = ref.read(tokenRepositoryProvider);
  return SaveTokensUseCase(repository);
});
