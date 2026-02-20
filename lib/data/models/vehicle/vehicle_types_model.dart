import 'package:crv_reprosisa/domain/entities/vehicle/vehicle_type.dart';

class VehicleTypesModel extends VehicleTypes{
  

  VehicleTypesModel({
    required super.id,
    required super.code,
    required super.name,
    super.description,
    required super.createdAt,
    required super.is_active,

  });
   factory VehicleTypesModel.fromJson(Map<String, dynamic> json) {
    return VehicleTypesModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      description: json['desciption'],
      createdAt: DateTime.parse(json['created_at']),
      is_active: json['is_active'],
    );

  }
}