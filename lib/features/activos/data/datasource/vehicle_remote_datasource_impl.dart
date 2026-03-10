import 'package:crv_reprosisa/features/activos/data/datasource/vehicle_remote_datasource.dart';
import 'package:crv_reprosisa/features/activos/data/models/vehicle_model.dart';
import 'package:crv_reprosisa/features/activos/domain/params/create_vehicle_params.dart';
import 'package:dio/dio.dart';

class VehicleRemoteDatasourceImpl implements VehicleRemoteDatasource {
  final Dio dio;

  VehicleRemoteDatasourceImpl(this.dio);

  @override
  Future<VehicleModel> createVehicle(CreateVehicleParams params) async {
    final response = await dio.post(
      '/vehicle/',
      data: {
        "type_id": params.typeId,
        "brand": params.brand,
        "model": params.model,
        "year": params.year,
        "license_plate": params.licensePlate,
      },
    );

    return VehicleModel.fromJson(response.data);
  }

  @override
  Future<List<VehicleModel>> getAllVehicle() async {
    final response = await dio.get("/vehicle/");

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response.data,
    );

    return data.map(VehicleModel.fromJson).toList();
  }
}
