import 'package:crv_reprosisa/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:crv_reprosisa/features/profile/data/datasources/profile_local_datasource_impl.dart';
import 'package:crv_reprosisa/features/profile/presentation/provider/change_password_notifier.dart';
import 'package:crv_reprosisa/features/profile/presentation/provider/change_password_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/config/dio_client.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/profile_use_case.dart';
import '../../data/datasources/profile_remote_datasource_impl.dart';

// 1. DataSource
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  return ProfileRemoteDataSourceImpl(ref.read(dioProvider));
});

final profileLocalDataSourceProvider = Provider<ProfileLocalDatasource>((ref) {
  return ProfileLocalDatasourceImpl(Hive.box('user_profile'));
});

// 2. Repository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    ref.read(profileRemoteDataSourceProvider),
    ref.read(profileLocalDataSourceProvider),
  );
});

// 3. UseCases
final getMeUseCaseProvider = Provider<GetMeUseCase>((ref) {
  return GetMeUseCase(ref.read(profileRepositoryProvider));
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  return UpdateProfileUseCase(ref.read(profileRepositoryProvider));
});

final changePasswordUseCaseProvider = Provider<ChangePasswordUseCase>((ref) {
  return ChangePasswordUseCase(ref.read(profileRepositoryProvider));
});

final changePasswordNotifierProvider =
    StateNotifierProvider<ChangePasswordNotifier, ChangePasswordState>((ref) {
      return ChangePasswordNotifier(ref.read(changePasswordUseCaseProvider));
    });
