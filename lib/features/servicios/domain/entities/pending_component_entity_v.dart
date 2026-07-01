// lib/features/assets/domain/entities/pending_component_entity.dart
class PendingComponentEntityV {
  final String id;
  final String vehicleId;
  final String serviceId;
  final String componentId;
  final String componentName;
  final String reportAnswerId;
  final String selectedOption;
  final String description;
  final String observation;
  final int incidenciasPrevias; // Nuevo campo calculado
  final String status;
  final DateTime completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  PendingComponentEntityV({
    required this.id,
    required this.vehicleId,
    required this.serviceId,
    required this.componentId,
    required this.componentName,
    required this.reportAnswerId,
    required this.incidenciasPrevias,
    required this.selectedOption,
    required this.description,
    required this.observation,
    required this.status,
    required this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });
}