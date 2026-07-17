import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/data/datasource/press_service_datasource.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/press/start_service_repository.dart';
import 'package:dartz/dartz.dart';

class StartServiceRepositoryImpl implements StartPressServiceRepository {
  final PressServiceDataSource remote;

  StartServiceRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, Unit>> startService({
    required String serviceId,
    required String observation
  }) async {
    try {
      await remote.startService(serviceId: serviceId, observation: observation);
      return Right(unit);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
