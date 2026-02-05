class AnswersConveyorModel {
  final String id;
  final String report_id;
  final String accedory_id;
  final String option_id;
  final String recommended_action;
  final DateTime createdAt;
  final DateTime updatedAt;

  AnswersConveyorModel({
    required this.id,
    required this.report_id,
    required this.accedory_id,
    required this.option_id,
    required this.recommended_action,
    required this.createdAt,
    required this.updatedAt,
  });
}