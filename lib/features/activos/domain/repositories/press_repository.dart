import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/activos/domain/entities/press.dart';
import 'package:crv_reprosisa/features/activos/domain/params/create_press_params.dart';
import 'package:dartz/dartz.dart';

abstract class PressRepository {
  Future<Either<Failure, Press>> createPress(CreatePressParams params);
  Future<Either<Failure, List<Press>>> getAllPress();
}
