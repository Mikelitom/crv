import '../../domain/entities/client_history.dart';

class ClientHistoryModel extends ClientHistory {
  ClientHistoryModel({required super.clientId, required super.clientName, required super.clientCompany, required super.mineId, required super.mineName, required super.areaId, required super.areaName, required super.conveyorId, required super.conveyorName, required super.reportId, required super.folio, required super.state, required super.inspectionDate, required super.material, required super.granulometry, required super.inspectorId, required super.inspectorName, required super.versionId, required super.versionNumber, required super.isCurrent, required super.answersCount, required super.evidencesCount});

  factory ClientHistoryModel.fromJson(Map<String, dynamic> json) => ClientHistoryModel(
        clientId: json['client_id'] ?? '',
        clientName: json['client_name'] ?? '',
        clientCompany: json['client_company'] ?? '',
        mineId: json['mine_id'] ?? '',
        mineName: json['mine_name'] ?? '',
        areaId: json['area_id'] ?? '',
        areaName: json['area_name'] ?? '',
        conveyorId: json['conveyor_id'] ?? '',
        conveyorName: json['conveyor_name'] ?? '',
        reportId: json['report_id'] ?? '',
        folio: json['folio'] ?? '',
        state: json['state'] ?? '',
        inspectionDate: DateTime.parse(json['inspection_date'] ?? DateTime.now().toIso8601String()),
        material: json['material'] ?? '',
        granulometry: json['granulometry'] ?? '',
        inspectorId: json['inspector_id'] ?? '',
        inspectorName: json['inspector_name'] ?? '',
        versionId: json['version_id'] ?? '',
        versionNumber: json['version_number'] ?? 0,
        isCurrent: json['is_current'] ?? false,
        answersCount: json['answers_count'] ?? 0,
        evidencesCount: json['evidences_count'] ?? 0,
      );
}