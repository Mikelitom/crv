import '../repositories/auth_repository.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  Future<Either<Failure, Unit>> call() {
    return repository.logout();
  }
}
