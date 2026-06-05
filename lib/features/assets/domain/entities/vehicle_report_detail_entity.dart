// lib/features/assets/domain/entities/vehicle_report_detail_entity.dart
import 'dart:typed_data'; // Necesario para Uint8List

class VehicleReportDetailEntity {
  final Map<String, dynamic> report;
  final VehicleInfoEntity vehicle;
  final VersionEntity version;
  final ResponsibleEntity responsible;
  final List<AnswerEntity> answers;

  VehicleReportDetailEntity({
    required this.report,
    required this.vehicle,
    required this.version,
    required this.responsible,
    required this.answers,
  });
}

class VehicleInfoEntity {
  final String vehicleId;
  final String brand;
  final String model;
  final int year;
  final String plate;
  final int unit;
  final String vehicleType;

  VehicleInfoEntity({
    required this.vehicleId, required this.brand, required this.model,
    required this.year, required this.plate, required this.unit, required this.vehicleType,
  });
}

class AnswerEntity {
  final String answerId;
  final String sectionName;
  final String componentName;
  final String optionName;
  final String observation;
  final List<String> evidencePaths;
  
  // ✅ CAMBIO: Propiedad opcional para transportar los bytes al PDF
  Uint8List? evidenceBytes; 

  AnswerEntity({
    required this.answerId, 
    required this.sectionName, 
    required this.componentName,
    required this.optionName, 
    required this.observation, 
    required this.evidencePaths,
    this.evidenceBytes, // Opcional
  });
}

// Clases simples para Version y Responsible
class VersionEntity { 
  final int versionNumber; 
  final bool isCurrent; 
  VersionEntity({required this.versionNumber, required this.isCurrent}); 
}

class ResponsibleEntity { 
  final String id; 
  final String name; 
  ResponsibleEntity({required this.id, required this.name}); 
}