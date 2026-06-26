import 'package:crv_reprosisa/features/servicios/domain/entities/v_service_order.dart';

class ServiceOrderModel extends ServiceOrder {
  ServiceOrderModel({
    required super.id,
    required super.vehicleId,
    required super.reportId,
    required super.description,
    required super.observation,
    required super.date,
    required super.status,
    required super.isActive
  });

  factory ServiceOrderModel.fromJson(Map<String, dynamic> json) {
    return ServiceOrderModel(
      id: json['id'],
      vehicleId: json['vehicle_id'],
      reportId: json['report_id'],
      description: json['description'] ?? '',
      observation: json['observation'] ?? '',
      date: DateTime.parse(json['date']),
      status: json['status'],
      isActive: json['is_active'],
    );
  }
}