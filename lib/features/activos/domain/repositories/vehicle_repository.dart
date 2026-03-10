import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/activos/domain/entities/vehicle.dart';

import 'package:crv_reprosisa/features/activos/domain/params/create_vehicle_params.dart';
import 'package:dartz/dartz.dart';

abstract class VehicleRepository {
  Future<Either<Failure, Vehicle>> createVehicle(CreateVehicleParams params);
  Future<Either<Failure, List<Vehicle>>> getAllVehicle();
}
