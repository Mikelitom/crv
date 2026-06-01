import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import 'package:crv_reprosisa/features/inspections/data/models/vehicle_report_detail_model.dart';
import '../repositories/inspection_repository.dart';

class GetVehicleReportDetailUseCase {
  final InspectionRepository repository;

  GetVehicleReportDetailUseCase(this.repository);
  Future<Either<Failure, VehicleReportDetailModel>> call(String id) async {
    return await repository.getVehicleReportDetail(id);
  }
}