// lib/features/servicios/data/models/press_service_order_model.dart
import 'package:crv_reprosisa/features/servicios/domain/entities/evidence.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/press_service_order_entity.dart';

class PressServiceOrderModel extends PressServiceOrderEntity {
  final DateTime createdAt;
  final DateTime updatedAt;

  const PressServiceOrderModel({
    required super.id,
    required super.pressId,
    required super.reportId,
    required super.description,
    required super.observation,
    required super.status,
    required super.date,
    required super.isActive,
    required super.evidences,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PressServiceOrderModel.fromJson(Map<String, dynamic> json) {
    return PressServiceOrderModel(
      id: json['id'] ?? '',
      pressId: json['press_id'] ?? '',
      reportId: json['report_id'] ?? '',
      description: json['description'] ?? 'Sin descripción',
      observation: json['observation'] ?? '',
      status: json['status'] ?? 'PENDING',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      evidences: json['evidences'] != null && json['evidences'] is List
          ? (json['evidences'] as List)
                .map((e) => Evidence.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
    );
  }
}
