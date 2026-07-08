import 'package:crv_reprosisa/features/servicios/domain/entities/vehicle_state.dart';


class VehicleStateModel extends VehicleStateEntity {
  VehicleStateModel({
    required super.id,
    required super.checkOut,
    super.checkIn, // Ahora es opcional/nulleable
  });

  factory VehicleStateModel.fromJson(Map<String, dynamic> json) {
    return VehicleStateModel(
      id: json['id']?.toString() ?? '',
      // Si check_out es null, asignamos una fecha muy vieja o now
      checkOut: json['check_out'] != null 
          ? DateTime.parse(json['check_out'].toString()) 
          : DateTime.now(),
      // Si check_in es null, asignamos DateTime.now() para que no truene
      checkIn: json['check_in'] != null 
          ? DateTime.parse(json['check_in'].toString()) 
          : DateTime.now(),
    );
  }
}