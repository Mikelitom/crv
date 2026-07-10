import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/vehicle_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateVehicleImage {
  final VehicleRepository repository;

  UpdateVehicleImage(this.repository);

  Future<Either<Failure, void>> call({
    required String id,
    required String imagePath,
  }) {
    return repository.updateVehicleImage(
      id,
      imagePath,
    );
  }
}