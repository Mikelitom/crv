
import 'dart:typed_data';

import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/vehicle_report_entity.dart';
import '../entities/conveyor_report_entity.dart';
import '../entities/press_report_entity.dart';

abstract class ReportRepository {
  Future<List<VehicleReportEntity>> getAllVehicleReports();
  Future<List<ConveyorReportEntity>> getAllConveyorReports();
  Future<List<PressReportEntity>> getAllPressReports();
  Future<void> sendConveyorReviewNote(String versionId, String notes);
  Future<void> acceptReport(String reportId);
  Future<Either<Failure, List<String>>> getClientEmails(String clientId);
  Future<Either<Failure, Unit>> sendReportEmail({
    required String versionId,
    required String email,
    required String message,
    required Uint8List pdfBytes,
  });
}
