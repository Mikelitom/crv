import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/data/datasource/v_service_datasource.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/vehicle/start_service_repository.dart';
import 'package:dartz/dartz.dart';

class StartServiceRepositoryImpl implements StartServiceRepository {
  final ServiceDataSource remote;

  StartServiceRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, Unit>> startService({
    required String serviceId,
    required String location,
    required int mileage
  }) async {
    try {
      await remote.startService(serviceId: serviceId, location: location, mileage:  mileage);
      return Right(unit);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
