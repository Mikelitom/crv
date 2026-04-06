import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/vehicle.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_vehicle_params.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/vehicle_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateVehicle {
  final VehicleRepository repository;

  UpdateVehicle(this.repository);

  Future<Either<Failure, Vehicle>> call(String id, CreateVehicleParams params) {
    return repository.updateVehicle(id, params);
  }
}
