import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> getMe();
  Future<Either<Failure, User>> updateProfile({String? name, String? phone});
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
    required bool logoutOthers,
  });
}