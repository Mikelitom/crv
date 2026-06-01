
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/vehicle_report_detail_entity.dart';
import '../repositories/vehicle_repository.dart';

class GetVehicleReportDetail {
  final VehicleRepository repository;

  GetVehicleReportDetail(this.repository);

  Future<Either<Failure, VehicleReportDetailEntity>> call(String reportId) async {
    return await repository.getVehicleReportDetail(reportId);
  }
}