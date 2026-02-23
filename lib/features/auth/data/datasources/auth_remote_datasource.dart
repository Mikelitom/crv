import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  });

  Future<AuthTokensModel> login({
    required String email,
    required String password,
  });

  Future<AuthTokensModel> refresh(String refreshToken);

  Future<UserModel> getMe();

  Future<void> logout();

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<bool> validateToken();
}
