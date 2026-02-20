import 'package:crv_reprosisa/domain/entities/press/answers_press.dart';

class AnswersPressModel extends AnswersPress{
  AnswersPressModel({
    required super.id,
    required super.report_id,
    required super.component_id,
    required super.quantity,
    required super.status,
    super.observation,
    required super.createdAt,
  });
 factory AnswersPressModel.fromJson(Map<String, dynamic> json) {
    return AnswersPressModel(
      id: json['id'],
      report_id: json['report_id'],
      component_id: json['component_id'],
      quantity: json['quantity'],
      status: json['status'],
      observation: json['observation'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}