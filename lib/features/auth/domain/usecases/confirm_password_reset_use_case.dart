import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class ConfirmPasswordResetUseCase {
  final AuthRepository repository;

  ConfirmPasswordResetUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String token, String newPassword) {
    return repository.confirmPasswordReset(
      token: token,
      newPassword: newPassword,
    );
  }
}