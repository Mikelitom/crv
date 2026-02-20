import 'package:crv_reprosisa/domain/entities/conveyors/answers_conveyor.dart';

class AnswersConveyorModel extends AnswersConveyor{
  AnswersConveyorModel({
    required super.id,
    required super.report_id,
    required super.accesory_id,
    required super.option_id,
    required super.recommended_action,
    required super.createdAt,
    required super.updatedAt,
  });
  factory AnswersConveyorModel.fromJson(Map<String, dynamic> json) {
    return AnswersConveyorModel(
      id: json['id'],
      report_id: json['report_id'],
      accesory_id: json['accesory_id'],
      option_id: json['option_id'],
      recommended_action: json['recommended_action'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),

    );
  }
}