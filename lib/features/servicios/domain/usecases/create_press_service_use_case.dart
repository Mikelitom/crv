import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/press_create_order_entity.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/create_press_service_repository.dart';

class CreatePressServiceUseCase {
  final CreatePressServiceRepository repository;

  CreatePressServiceUseCase(this.repository);

  Future<Either<Failure, String>> call(PressCreateOrderEntity entity) {
    return repository.createService(entity);
  }
}