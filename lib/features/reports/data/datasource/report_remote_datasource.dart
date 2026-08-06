import 'dart:typed_data';

import 'package:crv_reprosisa/features/reports/data/models/conveyor_history_model.dart';
import 'package:crv_reprosisa/features/reports/data/models/press_history_model.dart';
import 'package:crv_reprosisa/features/reports/data/models/vehicle_history_model.dart';

abstract class ReportRemoteDatasource {
  Future<List<VehicleHistoryModel>> getVehicleHistory();
  Future<List<ConveyorHistoryModel>> getConveyorHistory();
  Future<List<PressHistoryModel>> getPressHistory(); // <-- SIN parámetros
  Future<void> sendConveyorReviewNote(String versionId, String notes);
  Future<void> acceptReport(String reportId);
  Future<List<String>> getClientEmails(String clientId);
  Future<void> sendReportEmail({
    required String versionId,
    required String email,
    required String message,
    required Uint8List pdfBytes,
  });
}
