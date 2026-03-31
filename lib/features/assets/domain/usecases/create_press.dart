import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_press_params.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/press_repository.dart';
import 'package:dartz/dartz.dart';

class CreatePress {
  final PressRepository repository;

  CreatePress(this.repository);

  Future<Either<Failure, Press>> call(CreatePressParams params) {
    return repository.createPress(params);
  }
}
