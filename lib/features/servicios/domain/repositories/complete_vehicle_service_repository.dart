import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/evidence/presentation/dto/evidence_dto.dart';
import 'package:dartz/dartz.dart';

abstract class CompleteVehicleServiceRepository {
  Future<Either<Failure, bool>> completeService(String serviceId, List<EvidenceDto> evidences);
}
