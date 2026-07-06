import 'package:flutter/material.dart';

class PressItemEntity {
  final String id;
  final String pressId;
  final String serviceId;
  final String componentId;
  final String componentName;
  final String reportAnswerId;
  final int quantity;
  final String measureUnit;
  final String description;
  final String observation;
  final String status;
  final DateTime? completedAt;

  const PressItemEntity({
    required this.id,
    required this.pressId,
    required this.serviceId,
    required this.componentId,
    required this.componentName,
    required this.reportAnswerId,
    required this.quantity,
    required this.measureUnit,
    required this.description,
    required this.observation,
    required this.status,
    this.completedAt,
  });

  // Getters movidos a la entidad para acceso directo desde la UI
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