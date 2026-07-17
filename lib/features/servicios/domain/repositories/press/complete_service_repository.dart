import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/service_evidence.dart';
import 'package:dartz/dartz.dart';

abstract class CompleteServiceRepository {
  Future<Either<Failure, bool>> completeService(
    String serviceId,
    List<ServiceEvidence> evidences,
  );
}
