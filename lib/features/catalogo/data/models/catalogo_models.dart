import '../../../activos/domain/entities/press.dart';
import '../../../activos/domain/entities/vehicle.dart';


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
      id: json['id'] ?? '',
      typeId: json['type_id'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      licensePlate: json['plate'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      isActive: json['is_active'] ?? true,
    );
  }
}

class PressModel extends Press {
  PressModel({
    required super.id,
    required super.type,
    required super.model,
    required super.voltz,
    required super.serie,
    required super.size,
    required super.createdAt,
    required super.updatedAt,
    required super.isActive,
  });

  factory PressModel.fromJson(Map<String, dynamic> json) {
    return PressModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      model: json['model'] ?? '',
      voltz: json['voltz'] ?? '',
      serie: json['serie'] ?? '',
      size: json['size'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isActive: json['is_active'] ?? true,
    );
  }
}