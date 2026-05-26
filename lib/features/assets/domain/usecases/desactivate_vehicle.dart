import 'package:crv_reprosisa/features/assets/domain/repositories/vehicle_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';

class DeactivateVehicle {
  final VehicleRepository repository;
  DeactivateVehicle(this.repository);

  Future<Either<Failure, Unit>> call(String id) async => await repository.deactivateVehicle(id);
}