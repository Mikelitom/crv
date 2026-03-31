import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/press_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllPress {
  final PressRepository repository;

  GetAllPress(this.repository);

  Future<Either<Failure, List<Press>>> call() {
    return repository.getAllPress();
  }
}
