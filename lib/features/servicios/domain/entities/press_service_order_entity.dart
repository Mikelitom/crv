// lib/features/servicios/domain/entities/press_service_order_entity.dart
import 'package:crv_reprosisa/features/servicios/domain/entities/evidence.dart';

class PressServiceOrderEntity {
  final String id;
  final String pressId;
  final String reportId;
  final String description;
  final String observation;
  final String status;
  final DateTime date;
  final bool isActive;
  final List<Evidence> evidences;

  const PressServiceOrderEntity({
    required this.id,
    required this.pressId,
    required this.reportId,
    required this.description,
    required this.observation,
    required this.status,
    required this.date,
    required this.isActive,
    required this.evidences
  });

  String get formattedDate => "${date.day}/${date.month}/${date.year}";
}
