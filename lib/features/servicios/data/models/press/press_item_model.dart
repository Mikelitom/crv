import 'package:flutter/material.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/press_item_entity.dart';

class PressItemModel extends PressItemEntity {
  const PressItemModel({
    required super.id,
    required super.pressId,
    required super.serviceId,
    required super.componentId,
    required super.componentName,
    required super.reportAnswerId,
    required super.quantity,
    required super.measureUnit,
    required super.description,
    required super.observation,
    required super.status,
    super.completedAt,
  });

  factory PressItemModel.fromJson(Map<String, dynamic> json) {
    // Convertimos de forma segura:
    // 1. Tomamos el valor como num (puede ser int o double).
    // 2. Usamos .toInt() para forzarlo a entero.
    // 3. Usamos ?? 0 para evitar nulos.
    final rawQuantity = json['quantity'];
    final int parsedQuantity = (rawQuantity is num) ? rawQuantity.toInt() : 0;

    return PressItemModel(
      id: json['id'] ?? '',
      pressId: json['press_id'] ?? '',
      serviceId: json['service_id'] ?? '',
      componentId: json['component_id'] ?? '',
      componentName: json['component_name'] ?? 'Sin nombre',
      reportAnswerId: json['report_answer_id'] ?? '',
      quantity: parsedQuantity,
      measureUnit: json['measure_unit'] ?? '',
      description: json['description'] ?? '',
      observation: json['observation'] ?? '',
      status: json['status'] ?? 'PENDING',
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at']) 
          : null,
    );
  }
}