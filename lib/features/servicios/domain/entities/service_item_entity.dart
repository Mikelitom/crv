class ServiceItemEntity {
  final String id;
  final String serviceId;
  final String vehicleId;
  final String componentId;
  final String reportAnswerId;
  final String description;
  final String? observation;
  final String status;
  final DateTime? completedAt;

  const ServiceItemEntity({
    required this.id,
    required this.serviceId,
    required this.vehicleId,
    required this.componentId,
    required this.reportAnswerId,
    required this.description,
    this.observation,
    required this.status,
    this.completedAt,
  });
}