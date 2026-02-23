import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final FlutterSecureStorage storage;

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  AuthRepositoryImpl({required this.remote, required this.storage});

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remote.register(
        name: name,
        phone: phone,
        email: email,
        password: password,
      );

      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  }) async {
    try {
      final tokens = await remote.login(email: email, password: password);

      await storage.write(key: _accessKey, value: tokens.accessToken);
      await storage.write(key: _refreshKey, value: tokens.refreshToken);

      return Right(tokens);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshToken() async {
    try {
      final refresh = await storage.read(key: _refreshKey);

      final tokens = await remote.refresh(refresh!);

      await storage.write(key: _accessKey, value: tokens.accessToken);
      await storage.write(key: _refreshKey, value: tokens.refreshToken);

      return Right(tokens);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getMe() async {
    try {
      final user = await remote.getMe();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await remote.logout();
      await storage.deleteAll();
      return Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      remote.changePassword(oldPassword: oldPassword, newPassword: newPassword);
      return Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> validateToken() async {
    try {
      final valid = await remote.validateToken();
      return Right(valid);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
