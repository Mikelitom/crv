import 'package:crv_reprosisa/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class UserManagementRemoteDatasource {
  Future<List<UserModel>> getUsers();
  
Future<UserModel> updateUser({
  required String userId,
  List<String>? role, 
  String? scope,      
  bool? isActive,
});

  Future<Unit> deleteUser(String userId);
  Future<Unit> activateUser(String userId);
}