import 'package:crv_reprosisa/domain/entities/press/component_press.dart';

class ComponentPressModel extends ComponentPress{

  ComponentPressModel({
    required super.id,
    required super.name,
    required super.measure_unit,
    super.description,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active,
  });

   factory ComponentPressModel.fromJson(Map<String, dynamic> json) {
    return ComponentPressModel(
      id: json['id'],
      name: json['name'],
      measure_unit: json['measure_unit'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],

    );
  }
}