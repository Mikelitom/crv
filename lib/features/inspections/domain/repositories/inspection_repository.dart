import 'package:crv_reprosisa/features/inspections/data/models/vehicle_report_detail_model.dart';
import 'package:crv_reprosisa/features/inspections/domain/entities/inspection.dart';
import 'package:crv_reprosisa/features/inspections/domain/entities/vehicle_inspection.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../presentation/models/inspector_row_ui.dart';



abstract class InspectionRepository {
  Future<Either<Failure, List<InspectionRowUI>>> getMyInspections();
  Future<Either<Failure, Inspection>> getInspectionById(String id);
  Future<Either<Failure, List<VehicleInspection>>> getVehicleHistory(String vehicleId);
Future<Either<Failure, VehicleReportDetailModel>> getVehicleReportDetail(String id);}