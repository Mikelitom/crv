// lib/features/servicios/data/models/press_service_order_model.dart
import 'package:crv_reprosisa/features/servicios/domain/entities/press_service_order_entity.dart';


class PressServiceOrderModel extends PressServiceOrderEntity {
  const PressServiceOrderModel({
    required super.id,
    required super.pressId,
    required super.description,
    required super.observation,
    required super.status,
    required super.date,
    required super.isActive,
  });

  factory PressServiceOrderModel.fromJson(Map<String, dynamic> json) {
    return PressServiceOrderModel(
      id: json['id'] ?? '',
      pressId: json['press_id'] ?? '',
      description: json['description'] ?? 'Sin descripción',
      observation: json['observation'] ?? '',
      status: json['status'] ?? 'PENDING',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      isActive: json['is_active'] ?? false,
    );
  }
}