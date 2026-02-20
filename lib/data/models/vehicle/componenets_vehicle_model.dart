import 'package:crv_reprosisa/domain/entities/vehicle/components_vehicle.dart';

class ComponenetsVehicleModel extends ComponenetsVehicle{
 
  ComponenetsVehicleModel({
    required super.id,
    required super.section_id,
    required super.name,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active,
  });
   factory ComponenetsVehicleModel.fromJson(Map<String, dynamic> json) {
    return ComponenetsVehicleModel(
      id: json['id'],
      section_id: json['section_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],

    );
  }
}