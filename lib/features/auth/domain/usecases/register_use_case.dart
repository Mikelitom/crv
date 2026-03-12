import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    return repository.register(
      name: name,
      phone: phone,
      email: email,
      password: password,
    );
  }
}