import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/vehicle/start_service_repository.dart';
import 'package:dartz/dartz.dart';

class StartServiceUsecase {
  final StartServiceRepository repository;

  StartServiceUsecase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String serviceId,
    required String location,
    required int mileage,
  }) {
    return repository.startService(
      serviceId: serviceId,
      location: location,
      mileage: mileage,
    );
  }
}
