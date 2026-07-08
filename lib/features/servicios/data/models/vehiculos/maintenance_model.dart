import 'package:crv_reprosisa/features/servicios/domain/entities/maintenance_entity.dart';


class MaintenanceModel extends Maintenance {
  final String reportId;
  final String observation;
  final bool isActive;

  MaintenanceModel({
    required super.id,
    required super.vehicleId,
    required this.reportId,
    required super.orderNumber,
    required super.description,
    required this.observation,
    required super.date,
    required super.status,
    required this.isActive,
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceModel(
      id: json['id'],
      vehicleId: json['vehicle_id'],
      reportId: json['report_id'],
      orderNumber: json['order_number'],
      description: json['description'],
      observation: json['observation'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      isActive: json['is_active'],
    );
  }
}