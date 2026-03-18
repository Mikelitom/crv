import 'package:crv_reprosisa/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getMe();
  Future<UserModel> updateProfile({String? name, String? phone, String? email});
  Future<Unit> changePassword({
    required String currentPassword,
    required String newPassword,
    required bool logoutOthers,
  });
}
