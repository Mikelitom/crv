import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/vehicle_entity.dart';
import '../repositories/vehicle_inspeccion_repository.dart';

class GetActiveVehiclesUseCase {
  final VehicleInspectionRepository repository;
  GetActiveVehiclesUseCase(this.repository);

  Future<Either<Failure, List<Vehicle>>> call() async {
    return await repository.getActiveVehicles();
  }
}

