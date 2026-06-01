import 'package:dio/dio.dart';
import '../../presentation/models/inspector_row_ui.dart';

abstract class InspectionRemoteDataSource {
  Future<List<InspectionRowUI>> getMyInspections();
  Future<Map<String, dynamic>> getInspectionById(String id);
  Future<List<Map<String, dynamic>>> getVehicleHistory(String vehicleId);
Future<Map<String, dynamic>> getVehicleReportDetail(String id);}

class InspectionRemoteDataSourceImpl implements InspectionRemoteDataSource {
  final Dio dio;
  InspectionRemoteDataSourceImpl(this.dio);

  @override
  Future<List<InspectionRowUI>> getMyInspections() async {
    final response = await dio.get('/catalog/me');
    final List data = response.data;
    return data.map((e) => InspectionRowUI.fromJson(e)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getVehicleHistory(String vehicleId) async {
    final response = await dio.get(
      '/asset/vehicle-history',
      queryParameters: {'vehicle_id': vehicleId},
    );
    final List data = response.data;
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Future<Map<String, dynamic>> getInspectionById(String id) async {
    final response = await dio.get('/catalog/$id');
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getVehicleReportDetail(String id) async {
    final response = await dio.get('/asset/vehicle/$id');
        if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception("Formato de respuesta inesperado");
    }
  }
}
