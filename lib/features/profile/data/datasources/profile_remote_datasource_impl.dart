import 'package:crv_reprosisa/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import './profile_remote_datasource.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;
  ProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> getMe() async {
    final response = await dio.get("/auth/me/");
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? email,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (email != null) data['email'] = email;
    final response = await dio.patch("/auth/me", data: data);
    return UserModel.fromJson(response.data);
  }

  @override
  Future<Unit> changePassword({
    required String currentPassword,
    required String newPassword,
    required bool logoutOthers,
  }) async {
    await dio.post(
      "/auth/change-password",
      data: {
        'old_password': currentPassword,
        'new_password': newPassword,
      },
    );
    return unit;
  }
}
