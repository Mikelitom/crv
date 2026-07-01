import 'package:crv_reprosisa/features/servicios/domain/entities/press_item_entity.dart';
import 'package:flutter/material.dart';

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
    return PressItemModel(
      id: json['id'] ?? '',
      pressId: json['press_id'] ?? '',
      serviceId: json['service_id'] ?? '',
      componentId: json['component_id'] ?? '',
      componentName: json['component_name'] ?? 'Sin nombre',
      reportAnswerId: json['report_answer_id'] ?? '',
      quantity: json['quantity'] ?? 0,
      measureUnit: json['measure_unit'] ?? '',
      description: json['description'] ?? '',
      observation: json['observation'] ?? '',
      status: json['status'] ?? 'PENDING',
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at']) 
          : null,
    );
  }

  // Getters para UI (traducción y color como hicimos en vehicle)
  String get statusTranslated {
    switch (status.toUpperCase()) {
      case 'PENDING': return 'Pendiente';
      case 'IN_PROGRESS': return 'En proceso';
      case 'COMPLETED': return 'Completado';
      default: return 'Desconocido';
    }
  }

  Color get statusColor {
    switch (status.toUpperCase()) {
      case 'PENDING': return Colors.blue;
      case 'IN_PROGRESS': return Colors.orange;
      case 'COMPLETED': return Colors.green;
      default: return Colors.grey;
    }
  }
}