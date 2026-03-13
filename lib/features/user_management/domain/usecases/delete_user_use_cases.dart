import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import '../../domain/repositories/user_management_repository.dart';

class DeleteUser {
  final UserManagementRepository repository;

  DeleteUser(this.repository);

  Future<Either<Failure, Unit>> call(String userId) async {
    return await repository.deleteUser(userId);
  }
}

