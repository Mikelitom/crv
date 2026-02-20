import 'package:crv_reprosisa/domain/entities/conveyors/accesory_options_conveyor.dart';

class AccesoryOptionsConveyorModel extends AccesoryOptionsConveyor{
  AccesoryOptionsConveyorModel({
    required super.id,
    required super.accesory_id,
    required super.label,
    required super.value,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active,
  });
   factory AccesoryOptionsConveyorModel.fromJson(Map<String, dynamic> json) {
    return AccesoryOptionsConveyorModel(
      id: json['id'],
      accesory_id: json['accesory_id'],
      label: json['label'],
      value: json['value'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],


    );
  }
}