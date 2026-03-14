import 'package:crv_reprosisa/features/inspections/domain/entities/answers_press.dart';

class AnswersPressModel extends AnswersPress {
  AnswersPressModel({
    required super.id,
    required super.reportId,
    required super.componentId,
    required super.quantity,
    required super.status,
    super.observation,
    required super.createdAt,
  });
  factory AnswersPressModel.fromJson(Map<String, dynamic> json) {
    return AnswersPressModel(
      id: json['id'],
      reportId: json['report_id'],
      componentId: json['component_id'],
      quantity: json['quantity'],
      status: json['status'],
      observation: json['observation'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
