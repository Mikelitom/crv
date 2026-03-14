import 'package:crv_reprosisa/features/inspections/domain/entities/component_press.dart';

class ComponentPressModel extends ComponentPress {
  ComponentPressModel({
    required super.id,
    required super.name,
    required super.measureUnit,
    super.description,
    required super.createdAt,
    required super.updatedAt,
    required super.isActive,
  });

  factory ComponentPressModel.fromJson(Map<String, dynamic> json) {
    return ComponentPressModel(
      id: json['id'],
      name: json['name'],
      measureUnit: json['measure_unit'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isActive: json['is_active'],
    );
  }
}

