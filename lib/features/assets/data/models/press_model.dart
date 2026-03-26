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
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      voltz: json['voltz']?.toString() ?? '',
      serie: json['serie']?.toString() ?? '',
      size: json['size']?.toString() ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
      isActive: json['is_active'] ?? true,
    );
  }
}