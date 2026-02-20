import 'package:crv_reprosisa/domain/entities/vehicle/sections._vehicle.dart';

class SectionsVehicleModel extends SectionsVehicle {


  SectionsVehicleModel({
    required super.id,
    required super.name,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active,
  });
   factory SectionsVehicleModel.fromJson(Map<String, dynamic> json) {
    return SectionsVehicleModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],
     


    );
  }
}