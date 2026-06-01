import '../../domain/entities/vehicle_entity.dart';

class VehicleModel extends Vehicle {
  VehicleModel({
    required super.id,
    required super.typeId,
    required super.brand,
    required super.model,
    required super.unit,
    required super.year,
    required super.plate,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      typeId: json['type_id'],
      brand: json['brand'],
      model: json['model'],
      unit: json['unit'],
      year: json['year'],
      plate: json['plate'],
    );
  }
  String get unitDetail => "$brand $model $year";
}
