import 'package:dio/dio.dart';
import '../models/token_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<TokenModel> login(String email, String password) async {
    final response = await dio.post(
      '/api/v1/auth/login',
      data: {
        "email": email,
        "password": password,
      },
    );

    return TokenModel.fromJson(response.data);
  }
}