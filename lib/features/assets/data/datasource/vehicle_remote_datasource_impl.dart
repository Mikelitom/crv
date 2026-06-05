import 'package:crv_reprosisa/features/assets/data/datasource/vehicle_remote_datasource.dart';
import 'package:crv_reprosisa/features/assets/data/models/vehicle_model.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_vehicle_params.dart';
import 'package:dio/dio.dart';
import '../models/vehicle_report_detail_model.dart';
import '../../data/models/vehicle_report_detail_model.dart';
import 'package:crv_reprosisa/features/assets/data/models/vehicle_history_model.dart';

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
        "unit": params.unit,
        "year": params.year,
        "plate": params.plate.toUpperCase(),
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
        "brand": params.brand,
        "model": params.model,
        "unit": params.unit,
        "year": params.year,
        "plate": params.plate.toUpperCase(),
      },
    );

    return VehicleModel.fromJson(response.data);
  }

  @override
  Future<List<VehicleModel>> getAllVehicle() async {
    final response = await dio.get("/asset/vehicles");

    final List<dynamic> rawList = response.data;

    return rawList.map((json) {
      return VehicleModel.fromJson(json as Map<String, dynamic>);
    }).toList();
  }

  @override
  Future<void> activateVehicle(String id) async {
    await dio.patch("/vehicles/restore/$id");
  }
  @override
  Future<List<VehicleHistoryModel>> getVehicleHistory(String vehicleId) async {
    final response = await dio.get("/asset/vehicle-history", queryParameters: {
      "vehicle_id": vehicleId,
    });
    
    final List<dynamic> rawList = response.data;
    
    return rawList.map((json) {
      return VehicleHistoryModel.fromJson(json as Map<String, dynamic>);
    }).toList();
  }
 @override
Future<VehicleReportDetailModel> getVehicleReportDetail(String versionId) async {
  try {
    final response = await dio.get('/asset/vehicle/$versionId');
    return VehicleReportDetailModel.fromJson(response.data);
  } catch (e) {
    throw Exception("Error al obtener detalles por versión: $e");
  }
}

  @override
  Future<void> deactivateVehicle(String id) async {
    await dio.delete("/vehicles/$id");
  }
}
