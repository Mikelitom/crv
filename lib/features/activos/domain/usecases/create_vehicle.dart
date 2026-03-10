import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/activos/domain/entities/vehicle.dart';
import 'package:crv_reprosisa/features/activos/domain/params/create_vehicle_params.dart';
import 'package:crv_reprosisa/features/activos/domain/repositories/vehicle_repository.dart';
import 'package:dartz/dartz.dart';

class CreateVehicle {
  final VehicleRepository repository;

  CreateVehicle(this.repository);

  Future<Either<Failure, Vehicle>> call(CreateVehicleParams params) {
    return repository.createVehicle(params);
  }
}
