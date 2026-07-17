import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/service_evidence.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/press/complete_service_repository.dart';
import 'package:dartz/dartz.dart';

class CompleteServiceUsecase {
  final CompleteServiceRepository repository;

  CompleteServiceUsecase(this.repository);

  Future<Either<Failure, bool>> call(String serviceId, List<ServiceEvidence> evidences) {
    return repository.completeService(serviceId, evidences);
  }
}
