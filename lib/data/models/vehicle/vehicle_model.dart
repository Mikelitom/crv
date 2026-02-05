class VehicleModel {
  final String id;
  final String type_id;
  final String brand;
  final String model;
  final String year;
  final String license_plate;
  final DateTime createdA;
  final DateTime updatedAT;
  final bool is_active;

  VehicleModel ({
    required this.id,
    required this.type_id,
    required this.brand,
    required this.model,
    required this.year,
    required this.license_plate,
    required this.createdA,
    required this.updatedAT,
    required this.is_active,
  });
}