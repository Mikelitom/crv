import 'inspection.dart';

class VehicleInspection extends Inspection {
  final String vehicleId;
  final String brand;
  final String model;
  final int year;
  final String plate;
  final int unit;
  final String vehicleType;
  final int mileage;
  final bool requiresService;
  final String generalNotes;

  VehicleInspection({
    required super.id,
    required super.reportType,
    required super.title,
    required super.description,
    required super.folio,
    required super.state,
    required super.versionNumber,
    required super.date,
    required this.vehicleId,
    required this.brand,
    required this.model,
    required this.year,
    required this.plate,
    required this.unit,
    required this.vehicleType,
    required this.mileage,
    required this.requiresService,
    required this.generalNotes,
  });
}