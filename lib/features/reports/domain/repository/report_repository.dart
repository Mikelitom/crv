import '../entities/vehicle_report_entity.dart';
import '../entities/conveyor_report_entity.dart';
import '../entities/press_report_entity.dart';

abstract class ReportRepository {
  Future<List<VehicleReportEntity>> getAllVehicleReports();
  Future<List<ConveyorReportEntity>> getAllConveyorReports();
  Future<List<PressReportEntity>> getAllPressReports();
  Future<void> sendConveyorReviewNote(String versionId, String notes);
}