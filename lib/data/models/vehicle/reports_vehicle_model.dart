class ReportsVehicleModel {
  final String id;
  final String vehicle_id;
  final String reponsible_id;
  final DateTime inspection_date;
  final String mileage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool is_active;
  final bool requires_service;
  final String? observations;
  final String folio;
  final String state;

  ReportsVehicleModel({
    required this.id,
    required this.vehicle_id,
    required this.reponsible_id,
    required this.inspection_date,
    required this.mileage,
    required this.createdAt,
    required this.updatedAt,
    required this.is_active,
    required this.requires_service,
    this.observations,
    required this.folio,
    required this.state,
  });
}