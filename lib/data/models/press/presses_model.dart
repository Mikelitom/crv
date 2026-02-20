import 'package:crv_reprosisa/domain/entities/press/presses.dart';

class PressesModel extends Presses{

  PressesModel({
    required super.id,
    required super.type,
    required super.model,
    required super.voltz,
    required super.serie,
    required super.size,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active,
  });

  factory PressesModel.fromJson(Map<String, dynamic> json) {
    return PressesModel(
      id: json['id'],
      type: json['type'],
      model: json['model'],
      voltz: json['voltz'],
      serie: json['serie'],
      size: json['size'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],
      

    );
  }
}