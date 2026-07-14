import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/evidence/presentation/dto/evidence_dto.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/complete_vehicle_service_repository.dart';
import 'package:dartz/dartz.dart';

class CompleteVehicleServiceUsecase {
  final CompleteVehicleServiceRepository repository;

  CompleteVehicleServiceUsecase(this.repository);

  Future<Either<Failure, bool>> call(String serviceId, List<EvidenceDto> evidences) {
    return repository.completeService(serviceId, evidences);
  }
}
