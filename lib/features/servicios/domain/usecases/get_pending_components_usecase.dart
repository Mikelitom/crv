import 'package:crv_reprosisa/features/servicios/domain/repositories/pending_component_repository.dart';
import 'package:dartz/dartz.dart';
import '../entities/pending_component_entity_v.dart';

class GetPendingComponentsUseCase {
  final IPendingComponentRepository repository;
  GetPendingComponentsUseCase(this.repository);

  Future<Either<String, List<PendingComponentEntityV>>> call(String vehicleId) {
    return repository.getPendingComponents(vehicleId);
  }
}