import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/evidence/presentation/dto/evidence_dto.dart';
import 'package:crv_reprosisa/features/servicios/data/datasource/v_service_datasource.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/complete_vehicle_service_repository.dart';
import 'package:dartz/dartz.dart';

class CompleteVehicleServiceRepositoryImpl
    implements CompleteVehicleServiceRepository {
  final ServiceDataSource dataSource;

  CompleteVehicleServiceRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, bool>> completeService(String serviceId, List<EvidenceDto> evidences) async {
    try {
      await dataSource.completeService(serviceId, evidences);
      return const Right(true);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
