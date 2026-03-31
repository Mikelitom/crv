import '../../domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  VehicleModel({
    required super.id,
    required super.typeId,
    required super.brand,
    required super.model,
    required super.year,
    required super.licensePlate,
    required super.createdAt,
    required super.isActive,
  });
  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      typeId: json['type_id'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      licensePlate: json['plate'] ?? json['license_plate'],
      createdAt: DateTime.parse(json['created_at']),
      isActive: json['is_active'] ?? true
    );
  }
}

