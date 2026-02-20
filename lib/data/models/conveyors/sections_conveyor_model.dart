import 'package:crv_reprosisa/domain/entities/conveyors/sections_conveyor.dart';

class SectionsConveyorModel extends SectionsConveyor{
  

   SectionsConveyorModel({
    required super.id,
    required super.name,
    required super.createdAt,
    required super.updatedAt,
    super.is_active,
   });
   factory SectionsConveyorModel.fromJson(Map<String, dynamic> json) {
    return SectionsConveyorModel(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],
     


    );
  }
}