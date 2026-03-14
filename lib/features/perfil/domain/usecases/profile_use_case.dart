import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

class GetMeUseCase {
  final ProfileRepository repository;
  GetMeUseCase(this.repository);
  Future<Either<Failure, User>> call() => repository.getMe();
}

class UpdateProfileUseCase {
  final ProfileRepository repository;
  UpdateProfileUseCase(this.repository);
  Future<Either<Failure, User>> call({String? name, String? phone}) => 
    repository.updateProfile(name: name, phone: phone);
}

class ChangePasswordUseCase {
  final ProfileRepository repository;
  ChangePasswordUseCase(this.repository);
  Future<Either<Failure, Unit>> call({
    required String currentPassword,
    required String newPassword,
    required bool logoutOthers,
  }) => repository.changePassword(
    currentPassword: currentPassword,
    newPassword: newPassword,
    logoutOthers: logoutOthers,
  );
}