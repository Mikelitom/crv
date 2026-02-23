import '../entities/user.dart';
import '../entities/auth_tokens.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthTokens>> login({required String email, required String password});

  Future<Either<Failure, AuthTokens>> refreshToken();

  Future<Either<Failure, User>> getMe();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<Either<Failure, bool>> validateToken();
}
