import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/vehicle.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/vehicle_history.dart';
import '../entities/vehicle_report_detail_entity.dart';

import 'package:crv_reprosisa/features/assets/domain/params/create_vehicle_params.dart';
import 'package:dartz/dartz.dart';

abstract class VehicleRepository {
  Future<Either<Failure, Vehicle>> createVehicle(CreateVehicleParams params);
  Future<Either<Failure, Vehicle>> updateVehicle(String id, CreateVehicleParams params);
  Future<Either<Failure, List<Vehicle>>> getAllVehicle();
  Future<Either<Failure, Unit>> activateVehicle(String id);
  Future<Either<Failure, Unit>> deactivateVehicle(String id);
  Future<Either<Failure, List<VehicleHistory>>> getVehicleHistory(String vehicleId);
Future<Either<Failure, VehicleReportDetailEntity>> getVehicleReportDetail(String versionId);}
