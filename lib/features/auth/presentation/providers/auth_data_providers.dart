import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/core/storage/secure_storage_provider.dart';
import 'package:crv_reprosisa/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:crv_reprosisa/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:crv_reprosisa/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:crv_reprosisa/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.read(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remote: ref.read(authRemoteDataSourceProvider),
    storage: ref.read(secureStorageProvider),
  );
});
