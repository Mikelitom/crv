import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/press/start_service_repository.dart';
import 'package:dartz/dartz.dart';

class StartPressServiceUseCase {
  final StartPressServiceRepository repository;

  StartPressServiceUseCase(this.repository);

  Future<Either<Failure, Unit>> call({required String serviceId, required String observation}) {
    return repository.startService(serviceId: serviceId, observation: observation);
  }
}
