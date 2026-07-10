import 'package:dartz/dartz.dart';
// Verifica si tu carpeta core es 'error' o 'errors' y si el archivo es singular o plural
import '../../../../core/error/failure.dart'; 
import '../repositories/vehicle_inspeccion_repository.dart';

class UpdateVehicleReportUseCase {
  final VehicleInspectionRepository repository;

  UpdateVehicleReportUseCase(this.repository);

  Future<Either<Failure, String>> call(String reportId, Map<String, dynamic> data) async {
    return await repository.updateVehicleReport(reportId, data);
  }
}