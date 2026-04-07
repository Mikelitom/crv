import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_press_params.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/press_repository.dart';
import 'package:dartz/dartz.dart';

class UpdatePress {
  final PressRepository repository;

  UpdatePress(this.repository);

  Future<Either<Failure, Press>> call(String id, CreatePressParams params) {
    return repository.updatePress(id, params);
  }
}
