import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/press_repository.dart';
import 'package:dartz/dartz.dart';

class ActivatePress {
  final PressRepository repository;
  ActivatePress(this.repository);
  Future<Either<Failure, Unit>> call(String id) => repository.activatePress(id);
}