// lib/features/inspections/data/models/vehicle_report_detail_model.dart

class VehicleReportDetailModel {
  final Map<String, dynamic> report;
  final Map<String, dynamic> vehicle;
  final Map<String, dynamic> version;
  final Map<String, dynamic> responsible;
  final List<dynamic> answers;

  VehicleReportDetailModel({
    required this.report,
    required this.vehicle,
    required this.version,
    required this.responsible,
    required this.answers,
  });

  factory VehicleReportDetailModel.fromJson(Map<String, dynamic> json) {
    return VehicleReportDetailModel(
      report: json['report'] ?? {},
      vehicle: json['vehicle'] ?? {},
      version: json['version'] ?? {},
      responsible: json['responsible'] ?? {},
      answers: json['answers'] ?? [],
    );
  }
}