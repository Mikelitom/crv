import 'package:crv_reprosisa/domain/entities/vehicle/report_notes.dart';

class ReportNotesVehicleModel extends ReportNotesVehicle {

  ReportNotesVehicleModel({
    required super.id,
    required super.report_id,
    required super.note,
    required super.createdAt,
  });

  factory ReportNotesVehicleModel.fromJson(Map<String, dynamic> json) {
    return ReportNotesVehicleModel(
      id: json['id'],
      report_id: json['report_id'],
      note: json['note'],
      createdAt: DateTime.parse(json['created_at']),
     
    );
  }
}