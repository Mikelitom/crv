import 'package:dio/dio.dart';
import 'package:crv_reprosisa/features/vehiculos/data/models/inspection_vehicle_model.dart';

abstract class VehicleInspectionRemoteDataSource {
  Future<List<VehicleModel>> getActiveVehicles();
  Future<Map<String, dynamic>> getVehicleTemplate();
  Future<String> saveVehicleReport(Map<String, dynamic> reportData);
}

class VehicleInspectionRemoteDataSourceImpl
    implements VehicleInspectionRemoteDataSource {
  final Dio dio;
  VehicleInspectionRemoteDataSourceImpl(this.dio);

  @override
  Future<List<VehicleModel>> getActiveVehicles() async {
    try {
      final response = await dio.get('/vehicles/active');

      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response.data,
      );
      print("DEBUG: DataSource Response: ${response.data}");
      return data.map(VehicleModel.fromJson).toList();
    } catch (e) {
      print("DEBUG: DataSource Error: $e");
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getVehicleTemplate() async {
    try {
      final response = await dio.get('/template/vehicle');
      if (response.data != null) {
        return response.data as Map<String, dynamic>;
      }
      return {};
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> saveVehicleReport(Map<String, dynamic> reportData) async {
    try {
      // POST hacia el endpoint de reportes de vehículos
      final response = await dio.post(
        '/full-vehicle-reports',
        data: reportData,
      );
      return response.data['id'].toString();
    } catch (e) {
      rethrow;
    }
  }
}
