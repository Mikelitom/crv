import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/activos/domain/entities/vehicle.dart';
import 'package:crv_reprosisa/features/activos/domain/repositories/vehicle_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllVehicle {
  final VehicleRepository repository;

  GetAllVehicle(this.repository);

  Future<Either<Failure, List<Vehicle>>> call() {
    return repository.getAllVehicle();
  }
}
