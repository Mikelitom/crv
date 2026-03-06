import 'package:crv_reprosisa/domain/entities/vehicle/vehicle.dart';

class VehicleModel extends Vehicle{

  VehicleModel ({
    required super.id,
    required super.type_id,
    required super.brand,
    required super.model,
    required super.year,
    required super.license_plate,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active,
  });
  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      type_id: json['type_id'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      license_plate: json['license_plate'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],
    );

  }
}