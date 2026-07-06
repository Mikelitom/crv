// lib/features/assets/data/models/pending_component_model_v.dart
import 'package:crv_reprosisa/features/servicios/domain/entities/pending_component_entity_v.dart';

class PendingComponentModelV extends PendingComponentEntityV {
  PendingComponentModelV({
    required super.id,
    required super.vehicleId,
    required super.serviceId,
    required super.componentId,
    required super.componentName,
    required super.reportAnswerId,
    required super.selectedOption,
    required super.description,
    required super.observation,
    required super.status,
    required super.completedAt,
    required super.createdAt,
    required super.updatedAt,
    required super.incidenciasPrevias, // Nuevo campo
  });

  factory PendingComponentModelV.fromJson(Map<String, dynamic> json) {
    return PendingComponentModelV(
      id: json['id'] ?? '',
      vehicleId: json['vehicle_id'] ?? '',
      serviceId: json['service_id'] ?? '',
      componentId: json['component_id'] ?? '',
      componentName: json['component_name'] ?? 'Sin nombre',
      reportAnswerId: json['report_answer_id'] ?? '',
      selectedOption: json['selected_option'] ?? '',
      description: json['description'] ?? '',
      observation: json['observation'] ?? '',
      status: json['status'] ?? 'PENDIENTE',
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at']) 
          : DateTime.now(),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
      incidenciasPrevias: 0, // Se inicializa en 0, el Notifier lo actualizará
    );
  }
}