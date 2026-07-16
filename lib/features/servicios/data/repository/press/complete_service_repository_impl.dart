import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/data/datasource/press_service_datasource.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/service_evidence.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/press/complete_service_repository.dart';
import 'package:dartz/dartz.dart';

class CompleteServiceRepositoryImpl
    implements CompleteServiceRepository {
  final PressServiceDataSource dataSource;

  CompleteServiceRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, bool>> completeService(String serviceId, List<ServiceEvidence> evidences) async {
    try {
      await dataSource.completeService(serviceId, evidences);
      return const Right(true);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
