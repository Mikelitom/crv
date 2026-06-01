import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/vehicle_history.dart';
import '../repositories/vehicle_repository.dart';

class GetVehicleHistoryUseCase {
  final VehicleRepository repository;

  GetVehicleHistoryUseCase(this.repository);

  Future<Either<Failure, List<VehicleHistory>>> call(String vehicleId) async {
    return await repository.getVehicleHistory(vehicleId);
  }
}