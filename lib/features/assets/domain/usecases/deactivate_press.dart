import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/press_repository.dart';
import 'package:dartz/dartz.dart';

class DeactivatePress {
  final PressRepository repository;
  DeactivatePress(this.repository);
  Future<Either<Failure, Unit>> call(String id) => repository.deactivatePress(id);
}