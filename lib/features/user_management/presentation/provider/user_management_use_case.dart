import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_management_di.dart';
import '../../domain/usecases/get_users_use_cases.dart';
import '../../domain/usecases/update_user_use_cases.dart';
import '../../domain/usecases/delete_user_use_cases.dart';

final getUsersUseCaseProvider = Provider<GetUsers>((ref) {
  final repository = ref.read(userManagementRepositoryProvider);
  return GetUsers(repository);
});

final updateUserUseCaseProvider = Provider<UpdateUser>((ref) {
  final repository = ref.read(userManagementRepositoryProvider);
  return UpdateUser(repository);
});

final deactivateUserUseCaseProvider = Provider<DeleteUser>((ref) {
  final repository = ref.read(userManagementRepositoryProvider);
  return DeleteUser(repository);
});

