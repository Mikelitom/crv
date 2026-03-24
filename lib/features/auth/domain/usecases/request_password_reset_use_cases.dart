import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class RequestPasswordResetUseCase {
  final AuthRepository repository;

  RequestPasswordResetUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String email) {
    return repository.requestPasswordReset(email);
  }
}