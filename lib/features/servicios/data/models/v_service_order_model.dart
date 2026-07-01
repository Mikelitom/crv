import 'package:flutter/material.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/v_service_order.dart';

class ServiceOrderModel extends ServiceOrder {
  // Estos campos se agregan si no estaban en tu entidad base 'ServiceOrder'
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceOrderModel({
    required super.id,
    required super.vehicleId,
    required super.reportId,
    required super.description,
    required super.observation,
    required super.date,
    required super.status,
    required super.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceOrderModel.fromJson(Map<String, dynamic> json) {
    return ServiceOrderModel(
      id: json['id'] ?? '',
      vehicleId: json['vehicle_id'] ?? '',
      reportId: json['report_id'] ?? '',
      description: json['description'] ?? 'Sin descripción',
      observation: json['observation'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'PENDING',
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  // Traducción a español para la UI
  String get statusTranslated {
    switch (status.toUpperCase()) {
      case 'IN_PROGRESS': return 'EN PROCESO';
      case 'PENDING': return 'PENDIENTE';
      case 'COMPLETED': return 'COMPLETADO';
      default: return 'ABIERTA';
    }
  }

  // Colores para la UI
  Color get statusColor {
    switch (status.toUpperCase()) {
      case 'IN_PROGRESS': return Colors.blue;
      case 'PENDING': return Colors.orange;
      case 'COMPLETED': return Colors.green;
      default: return Colors.grey;
    }
  }
}