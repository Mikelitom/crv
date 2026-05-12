import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/vehicle_inspeccion_repository.dart';

class GetVehicleTemplateUseCase {
  final VehicleInspectionRepository repository;
  GetVehicleTemplateUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call() async {
    return await repository.getVehicleTemplate();
  }
}