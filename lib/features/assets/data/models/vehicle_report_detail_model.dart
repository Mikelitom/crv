// lib/features/assets/data/models/vehicle_report_detail_model.dart
import '../../domain/entities/vehicle_report_detail_entity.dart';

class VehicleReportDetailModel extends VehicleReportDetailEntity {
  VehicleReportDetailModel({
    required super.report,
    required super.vehicle,
    required super.version,
    required super.responsible,
    required super.answers,
  });

  factory VehicleReportDetailModel.fromJson(Map<String, dynamic> json) {
    return VehicleReportDetailModel(
      report: json['report'] ?? {},
      vehicle: VehicleInfoModel.fromJson(json['vehicle']),
      version: VersionModel.fromJson(json['version']),
      responsible: ResponsibleModel.fromJson(json['responsible']),
      answers: (json['answers'] as List).map((i) => AnswerModel.fromJson(i)).toList(),
    );
  }
}

class VehicleInfoModel extends VehicleInfoEntity {
  VehicleInfoModel({
    required super.vehicleId, 
    required super.brand, 
    required super.model, 
    required super.year, 
    required super.plate, 
    required super.unit, 
    required super.vehicleType
  });

  factory VehicleInfoModel.fromJson(Map<String, dynamic> json) => VehicleInfoModel(
    vehicleId: json['vehicle_id'] ?? '',
    brand: json['brand'] ?? '',
    model: json['model'] ?? '',
    year: json['year'] ?? 0,
    plate: json['plate'] ?? '',
    unit: json['unit'] ?? 0,
    vehicleType: json['vehicle_type'] ?? '',
  );
}

class AnswerModel extends AnswerEntity {
  AnswerModel({
    required super.answerId, 
    required super.sectionName, 
    required super.componentName, 
    required super.optionName, 
    required super.observation, 
    required super.evidencePaths
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) => AnswerModel(
    answerId: json['answer_id'] ?? '',
    sectionName: json['section']?['name'] ?? '',
    componentName: json['component']?['name'] ?? '',
    optionName: json['option']?['name'] ?? '',
    observation: json['observation'] ?? '',
    // CAMBIO APLICADO: Extraemos 'signed_url' para poder mostrar las imágenes en Flutter
    evidencePaths: (json['evidences'] as List<dynamic>?)
        ?.map((e) => e['signed_url']?.toString() ?? '')
        .where((url) => url.isNotEmpty)
        .toList() ?? [],
  );
}

class VersionModel extends VersionEntity {
  VersionModel({required super.versionNumber, required super.isCurrent});
  factory VersionModel.fromJson(Map<String, dynamic> json) => VersionModel(
    versionNumber: json['version_number'] ?? 0, 
    isCurrent: json['is_current'] ?? false
  );
}

class ResponsibleModel extends ResponsibleEntity {
  ResponsibleModel({required super.id, required super.name});
  factory ResponsibleModel.fromJson(Map<String, dynamic> json) => ResponsibleModel(
    id: json['id'] ?? '', 
    name: json['name'] ?? ''
  );
}