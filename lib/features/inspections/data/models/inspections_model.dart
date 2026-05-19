import '../../domain/entities/inspection.dart';

class InspectionModel extends Inspection {
  InspectionModel({
    required super.id, required super.reportType, required super.title,
    required super.description, required super.folio, required super.state,
    required super.versionNumber, required super.date,
  });

  factory InspectionModel.fromJson(Map<String, dynamic> json) {
    return InspectionModel(
      id: json['report_id'] ?? '',
      reportType: json['report_type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      folio: json['folio'] ?? '',
      state: json['state'] ?? '',
      versionNumber: (json['version_number'] is int) ? json['version_number'] : 0,
      date: json['inspection_date']?.toString().split('T')[0] ?? '',
    );
  }
}