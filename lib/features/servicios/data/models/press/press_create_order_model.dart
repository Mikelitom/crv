// lib/features/servicios/data/models/press/press_create_order_model.dart
import 'package:crv_reprosisa/features/servicios/domain/entities/press_create_order_entity.dart';

class PressCreateOrderModel extends PressCreateOrderEntity {
  const PressCreateOrderModel({
    required super.pressId,
    required super.description,
    required super.observation,
    required super.serviceItems,
  });

  /// Convierte el modelo a un mapa JSON utilizando las llaves exactas 
  /// requeridas por el endpoint POST /press/service
  Map<String, dynamic> toJson() {
    return {
      "press_id": pressId,           // Asegúrate que esta sea la llave exacta
      "description": description,
      "observation": observation,
      "service_items": serviceItems,
    };
  }

  /// Factory por si el servidor devuelve la orden creada
  factory PressCreateOrderModel.fromJson(Map<String, dynamic> json) {
    return PressCreateOrderModel(
      pressId: json['press_id'] as String,
      description: json['description'] as String,
      observation: json['observation'] as String,
      serviceItems: List<String>.from(json['service_items'] ?? []),
    );
  }
}