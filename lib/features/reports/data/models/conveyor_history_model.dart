import 'package:crv_reprosisa/features/reports/domain/entities/conveyor_report_entity.dart';

class ConveyorHistoryModel extends ConveyorReportEntity {
  final String clientId;
  final String mineName;
  final String areaName;

  // Getter para el filtrado
  String get tipo => "BANDA";

  ConveyorHistoryModel({
    required super.reportId, required super.folio, required super.state,
    required super.conveyorName, required super.clientCompany,
    required super.inspectorName, required super.versionNumber,
    required super.inspectionDate,
    required this.clientId, required this.mineName, required this.areaName,
  });

  factory ConveyorHistoryModel.fromJson(Map<String, dynamic> json) => ConveyorHistoryModel(
    reportId: json['report_id'] ?? '',
    folio: json['folio'] ?? '',
    state: json['state'] ?? 'PENDING',
    conveyorName: json['conveyor_name'] ?? '',
    clientCompany: json['client_company'] ?? '',
    inspectorName: json['inspector_name'] ?? '',
    versionNumber: json['version_number'] ?? 1,
    inspectionDate: DateTime.parse(json['inspection_date'] ?? DateTime.now().toIso8601String()),
    clientId: json['client_id'] ?? '',
    mineName: json['mine_name'] ?? '',
    areaName: json['area_name'] ?? '',
  );
}