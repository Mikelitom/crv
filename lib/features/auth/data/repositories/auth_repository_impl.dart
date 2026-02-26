import 'package:crv_reprosisa/features/auth/domain/repositories/token_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import 'package:crv_reprosisa/core/error/failure.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final TokenRepository tokenRepository;

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  AuthRepositoryImpl({required this.remote, required this.tokenRepository});

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

      // Convertimos UserModel a User entity
      final userEntity = User(
        id: userModel.id,
        name: userModel.name,
        email: userModel.email,
        phone: userModel.phone,
        isActive: userModel.isActive,
        lastLogin: userModel.lastLogin,
        createdAt: userModel.createdAt,
        roles: userModel.roles,
        permissions: userModel.permissions,
      );

      return Right(userEntity);
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

      await tokenRepository.save(tokens);

      return Right(tokens);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshToken() async {
    try {
      final refresh = await storage.read(key: _refreshKey);
      if (refresh == null) throw Exception('No refresh token found');

      final tokens = await remote.refresh(refresh);

      await tokenRepository.save(tokens);
      return Right(tokens);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getMe() async {
    try {
      final userModel = await remote.getMe();

      final userEntity = User(
        id: userModel.id,
        name: userModel.name,
        email: userModel.email,
        phone: userModel.phone,
        isActive: userModel.isActive,
        lastLogin: userModel.lastLogin,
        createdAt: userModel.createdAt,
        roles: userModel.roles,
        permissions: userModel.permissions,
      );

      return Right(userEntity);
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
      // Se añade await para capturar errores correctamente
      await remote.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
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

