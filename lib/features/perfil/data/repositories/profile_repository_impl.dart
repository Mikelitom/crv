import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remote;
  ProfileRepositoryImpl(this.remote);

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
  Future<Either<Failure, User>> updateProfile({String? name, String? phone}) async {
    try {
      final user = await remote.updateProfile(name: name, phone: phone);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword, 
    required String newPassword, 
    required bool logoutOthers
  }) async {
    try {
      await remote.changePassword(
        currentPassword: currentPassword, 
        newPassword: newPassword, 
        logoutOthers: logoutOthers
      );
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}