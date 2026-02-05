class PressLoansModel {
  final String id;
  final String report_id;
  final String press_id;
  final String reponsible_id;
  final String area;
  final String solicitants_name;
  final String? observations;
  final DateTime loan_date;
  final DateTime? expected_retunr_date;
  final DateTime? actual_return_date;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool is_active;

  PressLoansModel({
    required this.id,
    required this.report_id,
    required this.press_id,
    required this.reponsible_id,
    required this.area,
    required this.solicitants_name,
    this.observations,
    required this.loan_date,
    this.expected_retunr_date,
    this.actual_return_date,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.is_active,
  });
}