import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/create_service_order_entity.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/create_service_repository.dart';

class CreateServiceUseCase {
  final CreateServiceRepository repository;

  CreateServiceUseCase(this.repository);

  Future<Either<Failure, String>> call(CreateServiceOrderEntity entity) {
    return repository.createService(entity);
  }
}