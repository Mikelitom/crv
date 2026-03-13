import 'package:crv_reprosisa/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class UserManagementRemoteDatasource {
  Future<List<UserModel>> getUsers();
  
  Future<UserModel> updateUser({
    required String userId,
    String? role,
    String? area,
    bool? isActive,
  });

  Future<Unit> deleteUser(String userId);
}