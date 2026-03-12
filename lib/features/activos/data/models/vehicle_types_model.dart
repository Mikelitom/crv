import 'package:crv_reprosisa/features/activos/domain/entities/vehicle_type.dart';

class VehicleTypesModel extends VehicleType {
  VehicleTypesModel({
    required super.id,
    required super.code,
    required super.name,
    super.description,
    required super.createdAt,
    required super.isActive,
  });
  factory VehicleTypesModel.fromJson(Map<String, dynamic> json) {
    return VehicleTypesModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      description: json['desciption'],
      createdAt: DateTime.parse(json['created_at']),
      isActive: json['is_active'],
    );
  }
}
