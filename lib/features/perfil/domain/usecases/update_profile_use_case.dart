import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, User>> call({String? name, String? phone}) {
    return repository.updateProfile(name: name, phone: phone);
  }
}