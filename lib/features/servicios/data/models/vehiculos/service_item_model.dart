import 'package:flutter/material.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/service_item_entity.dart';

class ServiceItemModel extends ServiceItemEntity {
  const ServiceItemModel({
    required super.id,
    required super.serviceId,
    required super.vehicleId,
    required super.componentId,
    required super.reportAnswerId,
    required super.description,
    super.observation,
    required super.status,
    super.completedAt,
  });

  /// Traduce el status técnico a un formato amigable para el usuario
  String get statusTranslated {
    switch (this.status.toUpperCase()) {
      case 'PENDING':
        return 'Pendiente';
      case 'IN PROGRESS':
        return 'En proceso';
      case 'COMPLETED':
        return 'Completado';
      default:
        return 'Desconocido';
    }
  }

  /// Define el color asociado al estado del ítem
  Color get statusColor {
    switch (this.status.toUpperCase()) {
      case 'PENDING':
        return Colors.blue;
      case 'IN PROGRESS':
        return Colors.orange;
      case 'COMPLETED':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  factory ServiceItemModel.fromJson(Map<String, dynamic> json) {
    return ServiceItemModel(
      id: json['id'] ?? '',
      serviceId: json['service_id'] ?? '',
      vehicleId: json['vehicle_id'] ?? '',
      componentId: json['component_id'] ?? '',
      reportAnswerId: json['report_answer_id'] ?? '',
      description: json['description'] ?? '',
      observation: json['observation'],
      status: json['status'] ?? 'PENDING',
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at']) 
          : null,
    );
  }
}