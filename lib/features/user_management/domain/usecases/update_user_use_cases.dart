import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import '../../domain/repositories/user_management_repository.dart';

class UpdateUser {
  final UserManagementRepository repository;

  UpdateUser(this.repository);

  Future<Either<Failure, User>> call({
    required String userId,
    String? role,
    String? area,
    bool? isActive,
  }) async {
    return await repository.updateUser(
      userId: userId,
      role: role,
      area: area,
      isActive: isActive,
    );
  }
}

