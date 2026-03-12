import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/activos/domain/entities/vehicle_type.dart';
import 'package:dartz/dartz.dart';

abstract class VehicleTypeRepository {
  Future<Either<Failure, List<VehicleType>>> getAllTypes();
}
