// lib/features/assets/domain/entities/vehicle_report_detail_entity.dart

class VehicleReportDetailEntity {
  final Map<String, dynamic> report; // O puedes crear un ReportEntity si prefieres
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

  AnswerEntity({
    required this.answerId, required this.sectionName, required this.componentName,
    required this.optionName, required this.observation, required this.evidencePaths,
  });
}

// Clases simples para Version y Responsible
class VersionEntity { final int versionNumber; final bool isCurrent; VersionEntity({required this.versionNumber, required this.isCurrent}); }
class ResponsibleEntity { final String id; final String name; ResponsibleEntity({required this.id, required this.name}); }