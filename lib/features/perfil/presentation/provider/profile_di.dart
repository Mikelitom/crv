import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/dio_client.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/datasources/profile_remote_datasource_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/profile_use_case.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return ProfileRemoteDataSourceImpl(dio);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remote = ref.read(profileRemoteDataSourceProvider);
  return ProfileRepositoryImpl(remote);
});

final getMeProfileUseCaseProvider = Provider<GetMeUseCase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return GetMeUseCase(repository);
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return UpdateProfileUseCase(repository);
});

final changePasswordUseCaseProvider = Provider<ChangePasswordUseCase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return ChangePasswordUseCase(repository);
});