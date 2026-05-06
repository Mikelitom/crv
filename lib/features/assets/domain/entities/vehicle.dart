class Vehicle {
  final String id;
  final String typeId;
  final String brand;
  final String model;
  final int unit;
  final int year;
  final String plate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  Vehicle({
    required this.id,
    required this.typeId,
    required this.brand,
    required this.model,
    required this.unit,
    required this.year,
    required this.plate,
    required this.createdAt,
    this.updatedAt,
    required this.isActive,
  });
}
