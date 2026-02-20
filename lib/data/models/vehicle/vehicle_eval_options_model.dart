import 'package:crv_reprosisa/domain/entities/vehicle/vehicle_eval_options.dart';

class VehicleEvalOptionsModel extends VehicleEvalOptions{
  
  VehicleEvalOptionsModel({
    required super.id,
    required super.code,
    required super.name,
  });
  factory VehicleEvalOptionsModel.fromJson(Map<String, dynamic> json) {
    return VehicleEvalOptionsModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],

    );

  }
}