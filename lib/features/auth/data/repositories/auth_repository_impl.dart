import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;
  final FlutterSecureStorage storage;

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  AuthRepositoryImpl(this.remote, this.storage);

  @override
  Future<User> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    return remote.register(
      name: name,
      phone: phone,
      email: email,
      password: password,
    );
  }

  @override
  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    final tokens =
        await remote.login(email: email, password: password);

    await storage.write(key: _accessKey, value: tokens.accessToken);
    await storage.write(key: _refreshKey, value: tokens.refreshToken);

    return tokens;
  }

  @override
  Future<AuthTokens> refreshToken() async {
    final refresh =
        await storage.read(key: _refreshKey);

    final tokens = await remote.refresh(refresh!);

    await storage.write(key: _accessKey, value: tokens.accessToken);
    await storage.write(key: _refreshKey, value: tokens.refreshToken);

    return tokens;
  }

  @override
  Future<User> getMe() => remote.getMe();

  @override
  Future<void> logout() async {
    await remote.logout();
    await storage.deleteAll();
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) =>
      remote.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

  @override
  Future<bool> validateToken() =>
      remote.validateToken();
}