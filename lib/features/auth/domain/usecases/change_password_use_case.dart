import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class ChangePasswordUseCase {
    final AuthRepository repository;

    ChangePasswordUseCase(this.repository);

    Future<Either<Failure, Unit>> call(String oldPassword, String newPassword) {
        return repository.changePassword(oldPassword: oldPassword, newPassword: newPassword);        
    }
}



