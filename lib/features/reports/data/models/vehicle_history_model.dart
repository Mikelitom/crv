import 'package:crv_reprosisa/features/reports/domain/entities/vehicle_report_entity.dart';

class VehicleHistoryModel extends VehicleReportEntity {
  final String vehicleId;
  final String brand;
  final String model;

  // Getter para el filtrado
  String get tipo => "VEHICULO";

  VehicleHistoryModel({
    required super.reportId,
    required super.plate,
    required super.folio,
    required super.state,
    required super.responsibleName,
    required super.versionNumber,
    required super.inspectionDate,
    required this.vehicleId,
    required this.brand,
    required this.model,
  });

  factory VehicleHistoryModel.fromJson(Map<String, dynamic> json) {
    return VehicleHistoryModel(
      reportId: json['report_id'] ?? '',
      plate: json['plate'] ?? '',
      folio: json['folio'] ?? '',
      state: json['state'] ?? 'PENDING',
      responsibleName: json['responsible_name'] ?? 'N/A',
      versionNumber: json['version_number'] ?? 1,
      inspectionDate: DateTime.parse(json['inspection_date'] ?? DateTime.now().toIso8601String()),
      vehicleId: json['vehicle_id'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
    );
  }
}