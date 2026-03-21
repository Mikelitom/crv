import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';

abstract class UserManagementRepository {
  Future<Either<Failure, List<User>>> getUsers();

  Future<Either<Failure, User>> updateUser({
    required String userId,
    List<String>? role,
    String? scope,
    bool? isActive,
  });

  Future<Either<Failure, Unit>> deleteUser(String userId);
  Future<Either<Failure, Unit>> activateUser(String userId);
}

