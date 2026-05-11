import '../../domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  VehicleModel({
    required super.id,
    required super.typeId,
    required super.brand,
    required super.model,
    required super.unit,
    required super.year,
    required super.plate,
    required super.createdAt,
    required super.updatedAt,
    required super.isActive,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: _asString(json['id']),
      typeId: _asString(json['type_id']),
      brand: _asString(json['brand']),
      model: _asString(json['model']),
      plate: _asString(json['plate']),

      unit: _asInt(json['unit']),
      year: _asInt(json['year']),

      createdAt: _asDate(json['created_at']),
      updatedAt: _asDateNullable(json['updated_at']),

      isActive: _asBool(json['is_active']),
    );
  }

  // -------------------------
  // Parsers seguros (clave real)
  // -------------------------

  static String _asString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  static DateTime _asDate(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  static DateTime? _asDateNullable(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }
}

extension VehicleModelX on VehicleModel {
  String get unitDetail => "$brand $model $year";
}