import 'package:flutter/material.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/press_service_item_entity.dart';

class PressServiceItemModel extends PressServiceItemEntity {
  const PressServiceItemModel({
    required super.id,
    required super.componentName,
    required super.description,
    required super.status,
    required super.quantity,
    required super.measureUnit,
    required super.observation,
  });

  factory PressServiceItemModel.fromJson(Map<String, dynamic> json) {
    return PressServiceItemModel(
      id: json['id'] ?? '',
      // El JSON trae 'component_name'
      componentName: json['component_name'] ?? 'Sin nombre',
      // El JSON trae 'description'
      description: json['description'] ?? 'Sin descripción',
      // El JSON trae 'status'
      status: json['status'] ?? 'PENDIENTE',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      measureUnit: json['measure_unit'] ?? '',
      observation: json['observation'] ?? '',
    );
  }

  // Getters para UI (Estilo Vehículos)
  String get statusTranslated {
    switch (status.toUpperCase()) {
      case 'CRITICO': return 'Crítico';
      case 'ATENCION': return 'Atención';
      case 'PENDIENTE': return 'Pendiente';
      default: return status;
    }
  }

  Color get statusColor {
    switch (status.toUpperCase()) {
      case 'CRITICO': return const Color.fromARGB(255, 233, 18, 2);
      case 'ATENCION': return const Color.fromARGB(255, 255, 102, 0);
      case 'PENDIENTE': return const Color.fromARGB(255, 16, 52, 209);
      default: return Colors.grey;
    }
  }
}