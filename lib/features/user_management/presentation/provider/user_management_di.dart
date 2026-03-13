import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/dio_client.dart';
import '../../data/datasources/user_management_remote_datasource.dart';
import '../../data/datasources/user_management_remote_datasource_impl.dart';
import '../../data/repositories/user_management_repository_impl.dart';
import '../../domain/repositories/user_management_repository.dart';

final userManagementRemoteDatasourceProvider =
    Provider<UserManagementRemoteDatasource>((ref) {
      final dio = ref.read(dioProvider);
      return UserManagementRemoteDatasourceImpl(dio);
    });

final userManagementRepositoryProvider = Provider<UserManagementRepository>((
  ref,
) {
  final remote = ref.read(userManagementRemoteDatasourceProvider);
  return UserManagementRepositoryImpl(remote);
});
