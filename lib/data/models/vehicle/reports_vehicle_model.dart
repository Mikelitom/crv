import 'package:crv_reprosisa/domain/entities/vehicle/reports_vehicle.dart';

class ReportsVehicleModel extends ReportsVehicle{

  ReportsVehicleModel({
    required super.id,
    required super.vehicle_id,
    required super.responsible_id,
    required super.inspection_date,
    required super.mileage,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active,
    required super.requires_service,
    super.observations,
    required super.folio,
    required super.state,
  });
  factory ReportsVehicleModel.fromJson(Map<String, dynamic> json) {
    return ReportsVehicleModel(
      id: json['id'],
      vehicle_id: json['vehicle_id'],
      responsible_id: json['responsible_id'],
      inspection_date: DateTime.parse(json['inspection_date']),
      mileage: json['mileage'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],
      requires_service: json['requires_service'],
      observations: json['observations'],
      folio: json['folio'],
      state: json['state'],


    );
  }
}