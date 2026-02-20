import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../models/auth_tokens_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      '/api/v1/auth/register',
      data: {
        "name": name,
        "phone": phone,
        "email": email,
        "password": password,
        "role_names": ["users"],
      },
    );

    return UserModel.fromJson(response.data);
  }

  @override
  Future<AuthTokensModel> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      '/api/v1/auth/login',
      data: {"email": email, "password": password},
    );

    return AuthTokensModel.fromJson(response.data);
  }

  @override
  Future<AuthTokensModel> refresh(String refreshToken) async {
    final response = await dio.post(
      '/api/v1/auth/refresh',
      data: {"refresh_token": refreshToken},
    );

    return AuthTokensModel.fromJson(response.data);
  }

  @override
  Future<UserModel> getMe() async {
    final response = await dio.get('/api/v1/auth/me');
    return UserModel.fromJson(response.data);
  }
  
  @override
  Future<void> logout() async {
    await dio.post('/api/v1/auth/logout');
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await dio.post(
      '/api/v1/auth/change-password',
      data: {"old_password": oldPassword, "new_password": newPassword},
    );
  }

  @override
  Future<bool> validateToken() async {
    final response = await dio.get('/api/v1/auth/validate-token');

    return response.statusCode == 200;
  }
}
