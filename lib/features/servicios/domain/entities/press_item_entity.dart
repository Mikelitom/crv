class PressItemEntity {
  final String id;
  final String pressId;
  final String serviceId;
  final String componentId;
  final String componentName;
  final String reportAnswerId;
  final int quantity;
  final String measureUnit;
  final String description;
  final String observation;
  final String status;
  final DateTime? completedAt;

  const PressItemEntity({
    required this.id,
    required this.pressId,
    required this.serviceId,
    required this.componentId,
    required this.componentName,
    required this.reportAnswerId,
    required this.quantity,
    required this.measureUnit,
    required this.description,
    required this.observation,
    required this.status,
    this.completedAt,
  });
}