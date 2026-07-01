// lib/features/servicios/data/models/vehiculos/create_service_order_model.dart
import 'package:crv_reprosisa/features/servicios/domain/entities/create_service_order_entity.dart';

class CreateServiceOrderModel extends CreateServiceOrderEntity {
  const CreateServiceOrderModel({
    required super.vehicleId,
    required super.description,
    required super.observation,
    required super.serviceItems,
  });

  /// Convierte el modelo a un mapa JSON utilizando las llaves exactas 
  /// requeridas por el endpoint POST /vehicle/service
  Map<String, dynamic> toJson() {
    return {
      "vehicle_id": vehicleId,      // Clave exacta para el servidor
      "description": description,
      "observation": observation,
      "service_items": serviceItems, // Clave exacta para el servidor
    };
  }

  /// Factory opcional por si necesitas recrear el modelo desde un JSON
  factory CreateServiceOrderModel.fromJson(Map<String, dynamic> json) {
    return CreateServiceOrderModel(
      vehicleId: json['vehicle_id'] as String,
      description: json['description'] as String,
      observation: json['observation'] as String,
      serviceItems: List<String>.from(json['service_items'] ?? []),
    );
  }
}