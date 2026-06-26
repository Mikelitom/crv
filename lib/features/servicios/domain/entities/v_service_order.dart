class ServiceOrder {
  final String id;
  final String vehicleId;
  final String reportId;
  final String description;
  final String observation;
  final DateTime date;
  final String status;
  final bool isActive;

  ServiceOrder({
    required this.id,
    required this.vehicleId,
    required this.reportId,
    required this.description,
    required this.observation,
    required this.date,
    required this.status,
    required this.isActive,
  });
}