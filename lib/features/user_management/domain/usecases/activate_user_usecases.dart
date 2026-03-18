import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import '../../domain/repositories/user_management_repository.dart';



class ActivateUser {
  final UserManagementRepository repository;
  ActivateUser(this.repository);

  Future<Either<Failure, void>> call(String userId) async {
    return await repository.activateUser(userId);
  }
}

