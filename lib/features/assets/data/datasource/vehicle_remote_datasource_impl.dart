import 'package:crv_reprosisa/features/assets/data/datasource/vehicle_remote_datasource.dart';
import 'package:crv_reprosisa/features/assets/data/models/vehicle_model.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_vehicle_params.dart';
import 'package:dio/dio.dart';

class VehicleRemoteDatasourceImpl implements VehicleRemoteDatasource {
  final Dio dio;

  VehicleRemoteDatasourceImpl(this.dio);

  @override
  Future<VehicleModel> createVehicle(CreateVehicleParams params) async {
    try {
      final body = {
        "type_id": params.typeId,
        "brand": params.brand,
        "model": params.model,
        "year": params.year,
        "plate": params.licensePlate.toUpperCase(),
      };

      print("REQUEST BODY:");
      print(body);

      final response = await dio.post('/vehicles/', data: body);

      return VehicleModel.fromJson(response.data);
    } on DioException catch (e) {
      print("ERROR STATUS: ${e.response?.statusCode}");
      print("ERROR BODY: ${e.response?.data}");

      rethrow;
    }
  }

  @override
  Future<VehicleModel> updateVehicle(
    String id,
    CreateVehicleParams params,
  ) async {
    final response = await dio.put(
      '/vehicles/$id',
      data: {
        "type_id": params.typeId,
        "brand": params.brand,
        "model": params.model,
        "year": params.year,
        "plate": params.licensePlate.toUpperCase(),
      },
    );

    return VehicleModel.fromJson(response.data);
  }

  @override
  Future<List<VehicleModel>> getAllVehicle() async {
    final response = await dio.get("/vehicles/");

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response.data,
    );

    return data.map(VehicleModel.fromJson).toList();
  }
}
