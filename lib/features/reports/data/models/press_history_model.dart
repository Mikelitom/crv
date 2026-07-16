import 'package:crv_reprosisa/features/reports/domain/entities/press_report_entity.dart';

class PressHistoryModel extends PressReportEntity {
  final String pressId;
  final String model;
  final String type;
  final String area; // <--- 1. Agrega el campo aquí

  String get tipo => "PRENSA";

  PressHistoryModel({
    required String reportId,
    required String folio,
    required String state,
    required String serie,
    required String responsibleName,
    required int versionNumber,
    required DateTime inspectionDate,
    required this.pressId,
    required this.model,
    required this.type,
    required this.area, // <--- 2. Agrega al constructor
  }) : super(
          reportId: reportId,
          folio: folio,
          state: state,
          serie: serie,
          responsibleName: responsibleName,
          versionNumber: versionNumber,
          inspectionDate: inspectionDate,
        );

  factory PressHistoryModel.fromJson(Map<String, dynamic> json) => PressHistoryModel(
        reportId: json['report_id'] ?? '',
        folio: json['folio'] ?? '',
        state: json['state'] ?? 'PENDING',
        serie: json['serie'] ?? '',
        responsibleName: json['responsible_name'] ?? 'N/A',
        versionNumber: json['version_number'] ?? 1,
        inspectionDate: DateTime.parse(json['inspection_date'] ?? DateTime.now().toIso8601String()),
        pressId: json['press_id'] ?? '',
        model: json['model'] ?? '',
        type: json['type'] ?? '',
        area: json['area'] ?? 'N/A', // <--- 3. Agrega al fromJson
      );
}