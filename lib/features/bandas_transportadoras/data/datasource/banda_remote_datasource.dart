import 'package:dio/dio.dart';
import '../models/banda_models.dart';
import '../models/client_mine_model.dart';

abstract class BandaRemoteDataSource {
  Future<List<BandaSectionModel>> getBandaTemplate();
  Future<List<ClientModel>> getActiveClients();
  Future<List<MineModel>> getActiveMines();
  Future<String> saveBandaReport(Map<String, dynamic> reportData);
}

class BandaRemoteDataSourceImpl implements BandaRemoteDataSource {
  final Dio dio;
  BandaRemoteDataSourceImpl(this.dio);

  @override
  Future<List<BandaSectionModel>> getBandaTemplate() async {
    final response = await dio.get('/template/conveyor'); // Ajustar ruta según tu API
    final List data = response.data['sections'];
    return data.map((e) => BandaSectionModel.fromJson(e)).toList();
  }

  @override
  Future<List<ClientModel>> getActiveClients() async {
    final response = await dio.get('/clients/active');
    final List data = response.data;
    return data.map((e) => ClientModel.fromJson(e)).toList();
  }

  @override
  Future<List<MineModel>> getActiveMines() async {
    final response = await dio.get('/mines/active');
    final List data = response.data;
    return data.map((e) => MineModel.fromJson(e)).toList();
  }

  @override
  Future<String> saveBandaReport(Map<String, dynamic> reportData) async {
    final response = await dio.post('/banda-reports', data: reportData);
    return response.data['id'].toString();
  }
}