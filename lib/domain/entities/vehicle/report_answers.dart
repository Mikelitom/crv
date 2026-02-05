class ReportAnswersVehicle {
  final String id;
  final String report_id;
  final String componenet_id;
  final String option_id;
  final String? observations;
  final DateTime createdAt;

  ReportAnswersVehicle({
    required this.id,
    required this.report_id,
    required this.componenet_id,
    required this.option_id,
    this.observations,
    required this.createdAt,
  });
}