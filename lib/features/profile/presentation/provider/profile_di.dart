import 'package:crv_reprosisa/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:crv_reprosisa/features/profile/data/datasources/profile_local_datasource_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/config/dio_client.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/datasources/profile_remote_datasource_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/profile_use_case.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  final dio = ref.read(dioProvider);
  return ProfileRemoteDataSourceImpl(dio);
});

final profileLocalDataSourceProvider = Provider<ProfileLocalDatasource>((ref) {
  return ProfileLocalDatasourceImpl(Hive.box('user_profile'));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remote = ref.read(profileRemoteDataSourceProvider);
  final local = ref.read(profileLocalDataSourceProvider);
  return ProfileRepositoryImpl(remote, local);
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
