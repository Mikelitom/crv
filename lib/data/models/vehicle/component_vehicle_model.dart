import 'package:crv_reprosisa/domain/entities/vehicle/component_vehicle.dart';

class ComponentVehicleModel extends ComponentVehicle{
 
  ComponentVehicleModel({
    required super.id,
    required super.section_id,
    required super.name,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active,
  });
   factory ComponentVehicleModel.fromJson(Map<String, dynamic> json) {
    return ComponentVehicleModel(
      id: json['id'],
      section_id: json['section_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],

    );
  }
}