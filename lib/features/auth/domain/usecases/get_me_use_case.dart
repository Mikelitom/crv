import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetMeUseCase {
  final AuthRepository repository;

  GetMeUseCase(this.repository);

  Future<Either<Failure, User>> call() {
    return repository.getMe();
  }
}
