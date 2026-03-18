import 'dart:io';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/repositories/user_management_repository.dart';
import '../datasources/user_management_remote_datasource.dart';

class UserManagementRepositoryImpl implements UserManagementRepository {
  final UserManagementRemoteDatasource remote;

  UserManagementRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final users = await remote.getUsers();
      return Right(users);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser({
    required String userId,
    String? role,
    String? area,
    bool? isActive,
  }) async {
    try {
      final updatedUser = await remote.updateUser(
        userId: userId,
        role: role,
        area: area,
        isActive: isActive,
      );
      return Right(updatedUser);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUser(String userId) async {
    try {
      await remote.deleteUser(userId);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
   @override
  Future<Either<Failure, Unit>> activateUser(String userId) async {
    try {
      await remote.activateUser(userId);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
