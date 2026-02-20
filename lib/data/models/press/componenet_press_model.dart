import 'package:crv_reprosisa/domain/entities/press/componenet_press.dart';

class ComponenetPressModel extends ComponenetPress{

  ComponenetPressModel({
    required super.id,
    required super.name,
    required super.measure_unit,
    super.description,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active,
  });

   factory ComponenetPressModel.fromJson(Map<String, dynamic> json) {
    return ComponenetPressModel(
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