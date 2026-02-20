import 'package:crv_reprosisa/domain/entities/conveyors/accesories_conveyor.dart';

class AccesoriesConveyorModel extends AccesoriesConveyor {
  AccesoriesConveyorModel({
    required super.id,
    required super.section_id,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active,
    super.description,
    required super.name,
  });

  factory AccesoriesConveyorModel.fromJson(Map<String, dynamic> json) {
    return AccesoriesConveyorModel(
      id: json['id'],
      section_id: json['section_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],
      description: json['description'],
      name: json['name'],

    );
  }
}