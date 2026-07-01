import 'package:crv_reprosisa/features/servicios/domain/entities/incidence_entity.dart';


class IncidenceModel extends IncidenceEntity {
  const IncidenceModel({
    required super.vehicleId,
    required super.unit,
    required super.brand,
    required super.model,
    required super.componentId,
    required super.componentName,
    required super.incidenceCount,
    required super.lastIncidence,
  });

  factory IncidenceModel.fromJson(Map<String, dynamic> json) {
    return IncidenceModel(
      vehicleId: json['vehicle_id'] ?? '',
      unit: json['unit'] ?? 0,
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      componentId: json['component_id'] ?? '',
      componentName: json['component_name'] ?? 'Desconocido',
      incidenceCount: json['incidence_count'] ?? 0,
      lastIncidence: DateTime.parse(json['last_incidence'] ?? DateTime.now().toIso8601String()),
    );
  }
}