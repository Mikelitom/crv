import '../../domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  VehicleModel({
    required super.vehicleId,
    required super.plate,
    required super.brand,
    required super.model,
    required super.year,
    required super.unit,
    required super.isActive,
    required super.type,
    required super.operationState,
    required super.currentLocation,
    required super.responsible,
    required super.mileage,
    super.serviceReason,
    super.phone,
    super.serviceDate,
    super.checkoutDate,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      vehicleId: _asString(json['vehicle_id']),
      plate: _asString(json['plate']),
      brand: _asString(json['brand']),
      model: _asString(json['model']),
      year: _asInt(json['year']),
      unit: _asInt(json['unit']),
      isActive: _asBool(json['is_active']),
      type: _asString(json['type']),
      operationState: _asString(json['operation_state']),
      currentLocation: _asString(json['current_location']),
      responsible: _asString(json['responsible']),
      mileage: _asInt(json['mileage']),
      // Campos de auditoría dinámicos planos del endpoint
      serviceReason: json['service_reason'] != null ? _asString(json['service_reason']) : null,
      phone: json['phone'] != null ? _asString(json['phone']) : null,
      serviceDate: json['service_date'] != null ? _asString(json['service_date']) : null,
      checkoutDate: json['checkout_date'] != null ? _asString(json['checkout_date']) : null,
    );
  }

  static String _asString(dynamic value) {
    if (value == null) return '';
    return value.toString().trim();
  }

  static int _asInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static bool _asBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }
}