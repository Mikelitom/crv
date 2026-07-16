import 'package:dio/dio.dart';
import '../models/vehicle_history_model.dart';
import '../models/conveyor_history_model.dart';
import '../models/press_history_model.dart';
import 'report_remote_datasource.dart';

class ReportRemoteDatasourceImpl implements ReportRemoteDatasource {
  final Dio dio;

  ReportRemoteDatasourceImpl(this.dio);

  @override
  Future<List<VehicleHistoryModel>> getVehicleHistory() async {
    // Llamada al endpoint global sin filtrar por ID
    final response = await dio.get('/asset/vehicle-history');
    final List<dynamic> data = response.data;
    return data.map((json) => VehicleHistoryModel.fromJson(json)).toList();
  }

  @override
  Future<List<ConveyorHistoryModel>> getConveyorHistory() async {
    final response = await dio.get('/asset/client-history');
    final List<dynamic> data = response.data;
    return data.map((json) => ConveyorHistoryModel.fromJson(json)).toList();
  }

  @override
  Future<List<PressHistoryModel>> getPressHistory() async {
    final response = await dio.get('/asset/press-history');
    final List<dynamic> data = response.data;
    return data.map((json) => PressHistoryModel.fromJson(json)).toList();
  }
}
