class Vehicle {
  final String id;
  final String typeId;
  final String brand;
  final String model;
  final int year;
  final String licensePlate;
  final DateTime createdAt;
  final bool isActive;

  Vehicle({
    required this.id,
    required this.typeId,
    required this.brand,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.createdAt,
    required this.isActive,
  });
}
