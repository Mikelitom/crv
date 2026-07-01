// lib/features/servicios/domain/entities/press_service_order_entity.dart
class PressServiceOrderEntity {
  final String id;
  final String pressId;
  final String description;
  final String observation;
  final String status;
  final DateTime date;
  final bool isActive;

  const PressServiceOrderEntity({
    required this.id,
    required this.pressId,
    required this.description,
    required this.observation,
    required this.status,
    required this.date,
    required this.isActive,
  });

  String get formattedDate => "${date.day}/${date.month}/${date.year}";
}