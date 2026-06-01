import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/vehicle_inspection.dart';
import '../repositories/inspection_repository.dart';

class GetVehicleHistoryUseCase {
  final InspectionRepository repository;
  GetVehicleHistoryUseCase(this.repository);

  Future<Either<Failure, List<VehicleInspection>>> call(String vehicleId) async {
    return await repository.getVehicleHistory(vehicleId);
  }
}