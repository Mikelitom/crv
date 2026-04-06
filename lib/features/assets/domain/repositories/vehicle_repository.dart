import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/vehicle.dart';

import 'package:crv_reprosisa/features/assets/domain/params/create_vehicle_params.dart';
import 'package:dartz/dartz.dart';

abstract class VehicleRepository {
  Future<Either<Failure, Vehicle>> createVehicle(CreateVehicleParams params);
  Future<Either<Failure, Vehicle>> updateVehicle(String id, CreateVehicleParams params);
  Future<Either<Failure, List<Vehicle>>> getAllVehicle();
}
