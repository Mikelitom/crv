class Vehicle {
  final String id;
  final String type_id;
  final String brand;
  final String model;
  final String year;
  final String license_plate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool is_active;

  Vehicle ({
    required this.id,
    required this.type_id,
    required this.brand,
    required this.model,
    required this.year,
    required this.license_plate,
    required this.createdAt,
    required this.updatedAt,
    required this.is_active,
  });
}