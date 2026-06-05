import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/vehicle_entity.dart';

abstract class VehicleInspectionRepository {
  Future<Either<Failure, List<Vehicle>>> getActiveVehicles();
  Future<Either<Failure, String>> saveVehicleReport(
    Map<String, dynamic> reportData,
  );
  Future<Either<Failure, Map<String, dynamic>>> getVehicleTemplate();
}
