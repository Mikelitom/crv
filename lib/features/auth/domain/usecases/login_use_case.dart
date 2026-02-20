import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, AuthTokens>> call(String email, String password) {
    return repository.login(email: email, password: password);
  }
}
