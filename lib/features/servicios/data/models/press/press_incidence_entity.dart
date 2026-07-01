// lib/features/servicios/data/models/press_incidence_model.dart
import 'package:crv_reprosisa/features/servicios/domain/entities/press_incidence_entity.dart';


class PressIncidenceModel extends PressIncidenceEntity {
  const PressIncidenceModel({
    required super.pressId,
    required super.serie,
    required super.model,
    required super.componentId,
    required super.componentName,
    required super.incidenceCount,
    required super.lastIncidence,
  });

  factory PressIncidenceModel.fromJson(Map<String, dynamic> json) {
    return PressIncidenceModel(
      pressId: json['press_id'] ?? '',
      serie: json['serie'] ?? '',
      model: json['model'] ?? '',
      componentId: json['component_id'] ?? '',
      componentName: json['component_name'] ?? 'Sin nombre',
      incidenceCount: json['incidence_count'] ?? 0,
      lastIncidence: DateTime.parse(json['last_incidence'] ?? DateTime.now().toIso8601String()),
    );
  }
}