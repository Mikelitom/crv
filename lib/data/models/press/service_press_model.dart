import 'package:crv_reprosisa/domain/entities/press/service_press.dart';

class ServicePressModel extends ServicePress {


  ServicePressModel({
    required super.id,
    required super.press_id,
    required super.description,
    required super.observation,
    required super.date,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active,
  });
  factory ServicePressModel.fromJson(Map<String, dynamic> json) {
    return ServicePressModel(
      id: json['id'],
      press_id: json['press_id'],
      description: json['desciption'],
      observation: json['observation'],
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],

    );

  }
}