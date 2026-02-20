import 'package:crv_reprosisa/domain/entities/conveyors/area.dart';

class AreaModel extends Area{
  AreaModel({
    required super.id,
    required super.client_id,
    required super.name,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active
  });
  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id'],
      client_id: json['client_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],


    );
  }
}