import 'package:crv_reprosisa/domain/entities/vehicle/vehicle_state.dart';

class VehicleStateModel extends VehicleState {
 
  VehicleStateModel({
    required super.id,
    required super.vehicle_id,
    required super.state,
    required super.responsible_id,
    required super.location,
    required super.check_out,
    required super.check_in,
    required super.mileage,
    required super.createdAt,
    required super.updatedAt,
    required super.is_active

  });
    factory VehicleStateModel.fromJson(Map<String, dynamic> json) {
    return VehicleStateModel(
      id: json['id'],
      vehicle_id: json['vehicle_id'],
      state: json['state'],
      responsible_id: json['responsible_id'],
      location: json['location'],
      check_out: DateTime.parse(json['check_out']),
      check_in: DateTime.parse(json['check_in']),
      mileage: json['mileage'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      is_active: json['is_active'],
    );

  }
}
