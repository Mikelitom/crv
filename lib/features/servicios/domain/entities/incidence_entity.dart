class IncidenceEntity {
  final String vehicleId;
  final int unit;
  final String brand;
  final String model;
  final String componentId;
  final String componentName;
  final int incidenceCount;
  final DateTime lastIncidence;

  const IncidenceEntity({
    required this.vehicleId,
    required this.unit,
    required this.brand,
    required this.model,
    required this.componentId,
    required this.componentName,
    required this.incidenceCount,
    required this.lastIncidence,
  });
}