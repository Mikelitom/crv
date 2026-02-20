import 'package:crv_reprosisa/domain/entities/conveyors/conveyors.dart';

class ConveyorsModel extends Conveyors{
  ConveyorsModel({
    required super.id,
    required super.area_id,
    required super.name,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active,
  });
 factory ConveyorsModel.fromJson(Map<String, dynamic> json) {
    return ConveyorsModel(
      id: json['id'],
      area_id: json['area_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],

    );
}
}