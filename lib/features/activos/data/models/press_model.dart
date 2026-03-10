import '../../domain/entities/press.dart';

class PressModel extends Press {
  PressModel({
    required super.id,
    required super.type,
    required super.model,
    required super.voltz,
    required super.serie,
    required super.size,
    required super.createdAt,
    required super.updatedAt,
    required super.isActive,
  });

  factory PressModel.fromJson(Map<String, dynamic> json) {
    return PressModel(
      id: json['id'],
      type: json['type'],
      model: json['model'],
      voltz: json['voltz'],
      serie: json['serie'],
      size: json['size'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isActive: json['is_active'],
    );
  }
}
