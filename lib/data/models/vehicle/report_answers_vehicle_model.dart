import 'package:crv_reprosisa/domain/entities/vehicle/report_answers.dart';

class ReportAnswersVehicleModel extends ReportAnswersVehicle{

  ReportAnswersVehicleModel({
    required super.id,
    required super.report_id,
    required super.component_id,
    required super.option_id,
    super.observations,
    required super.createdAt,
  });
  factory ReportAnswersVehicleModel.fromJson(Map<String, dynamic> json) {
    return ReportAnswersVehicleModel(
      id: json['id'],
      report_id: json['report_id'],
      component_id: json['component_id'],
      option_id: json['option_id'],
      observations: json['observations'],
      createdAt: DateTime.parse(json['created_at']),
     
    );
  }
}