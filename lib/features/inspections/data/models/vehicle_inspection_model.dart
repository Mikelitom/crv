import '../../domain/entities/vehicle_inspection.dart';

class VehicleInspectionModel extends VehicleInspection {
  VehicleInspectionModel({
    required super.id,
    required super.reportType,
    required super.title,
    required super.description,
    required super.folio,
    required super.state,
    required super.versionNumber,
    required super.date,
    required super.vehicleId,
    required super.brand,
    required super.model,
    required super.year,
    required super.plate,
    required super.unit,
    required super.vehicleType,
    required super.mileage,
    required super.requiresService,
    required super.generalNotes,
  });

  factory VehicleInspectionModel.fromJson(Map<String, dynamic> json) {
    return VehicleInspectionModel(
      id: json['report_id'],
      reportType: 'VEHICLE',
      title: 'Reporte Vehículo', // O el campo que traiga el título
      description: '', 
      folio: json['folio'] ?? '',
      state: json['state'] ?? '',
      versionNumber: json['version_number'] ?? 0,
      date: json['inspection_date']?.toString().split('T')[0] ?? '',
      vehicleId: json['vehicle_id'],
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      plate: json['plate'] ?? '',
      unit: json['unit'] ?? 0,
      vehicleType: json['vehicle_type'] ?? '',
      mileage: json['mileage'] ?? 0,
      requiresService: json['requires_service'] ?? false,
      generalNotes: json['general_notes'] ?? '',
    );
  }
}