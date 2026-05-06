import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/vehicle_inspeccion_repository.dart';

class CreateVehicleReportUseCase {
  final VehicleInspectionRepository repository;
  CreateVehicleReportUseCase(this.repository);

  Future<Either<Failure, String>> call(Map<String, dynamic> reportData) async {
    return await repository.saveVehicleReport(reportData);
  }
}