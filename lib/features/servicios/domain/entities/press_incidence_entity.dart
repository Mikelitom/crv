// lib/features/servicios/domain/entities/press_incidence_entity.dart
class PressIncidenceEntity {
  final String pressId;
  final String serie;
  final String model;
  final String componentId;
  final String componentName;
  final int incidenceCount;
  final DateTime lastIncidence;

  const PressIncidenceEntity({
    required this.pressId,
    required this.serie,
    required this.model,
    required this.componentId,
    required this.componentName,
    required this.incidenceCount,
    required this.lastIncidence,
  });

  String get formattedDate => "${lastIncidence.day}/${lastIncidence.month}/${lastIncidence.year}";
}