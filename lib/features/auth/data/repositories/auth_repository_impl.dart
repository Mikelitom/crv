import 'package:crv_reprosisa/features/auth/domain/repositories/token_repository.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import 'package:crv_reprosisa/core/error/failure.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final TokenRepository tokenRepository;

  AuthRepositoryImpl({required this.remote, required this.tokenRepository});

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      final user = await remote.register(
        name: name,
        phone: phone,
        email: email,
        password: password,
      );

      return Right(user);
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
      final storedTokens = await tokenRepository.get();

      if (storedTokens == null) {
        return Left(ServerFailure('No refresh token stored'));
      }

      final newTokens = await remote.refresh(storedTokens.refreshToken);

      await tokenRepository.save(newTokens);

      return Right(newTokens);
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
      await tokenRepository.clear();
      return const Right(unit);
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
      await remote.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      return const Right(unit);
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
