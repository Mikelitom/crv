import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/service_evidence.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/complete_vehicle_service_repository.dart';
import 'package:dartz/dartz.dart';

class CompleteVehicleServiceUsecase {
  final CompleteVehicleServiceRepository repository;

  CompleteVehicleServiceUsecase(this.repository);

  Future<Either<Failure, bool>> call(String serviceId, List<ServiceEvidence> evidences) {
    return repository.completeService(serviceId, evidences);
  }
}
