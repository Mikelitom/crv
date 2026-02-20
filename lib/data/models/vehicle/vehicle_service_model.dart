import 'package:crv_reprosisa/domain/entities/vehicle/vehicle_service.dart';

class VehicleServiceModel extends VehicleService{

  VehicleServiceModel({
    required super.id,
    required super.vehicle_id,
    required super.description,
    required super.observation,
    required super.date,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active,
  });
  factory VehicleServiceModel.fromJson(Map<String, dynamic> json) {
    return VehicleServiceModel(
      id: json['id'],
      vehicle_id: json['user_id'],
      description: json['desciption'],
      observation: json['observation'],
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],
    );

  }
}