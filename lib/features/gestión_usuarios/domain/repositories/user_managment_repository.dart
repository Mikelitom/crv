import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';

abstract class UserManagementRepository {
  Future<Either<Failure, List<User>>> getUsers();

  Future<Either<Failure, User>> updateUser({
    required String userId,
    String? role,
    String? area,
    bool? isActive,
  });

  Future<Either<Failure, Unit>> deleteUser(String userId);
}