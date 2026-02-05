class AnswersPressModel {
  final String id;
  final String report_id;
  final String component_id;
  final double quantity;
  final String status;
  final String? observation;
  final DateTime createdAt;

  AnswersPressModel({
    required this.id,
    required this.report_id,
    required this.component_id,
    required this.quantity,
    required this.status,
    this.observation,
    required this.createdAt,
  });

}