import 'package:dio/dio.dart';
import '../models/press_model.dart';

abstract class InspeccionRemoteDataSource {
  Future<PressModel?> getPressBySerie(String serie);
  Future<void> savePressReport(Map<String, dynamic> reportData);
  Future<List<String>> getAllSeries();
  // NUEVO: Petición al endpoint del template
  Future<List<dynamic>> getInspectionTemplate();
}

class InspeccionRemoteDataSourceImpl implements InspeccionRemoteDataSource {
  final Dio dio;
  InspeccionRemoteDataSourceImpl(this.dio);

  @override
  Future<List<dynamic>> getInspectionTemplate() async {
    try {
      // El endpoint que nos da los componentes
      final response = await dio.get('/template/press');

      if (response.data != null && response.data['components'] != null) {
        return response.data['components'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PressModel?> getPressBySerie(String serie) async {
    try {
      final response = await dio.get(
        '/presses/filter',
        queryParameters: {'key_name': 'serie', 'key_value': serie},
      );

      if (response.data is List && (response.data as List).isNotEmpty) {
        final firstItem = (response.data as List).first;
        return PressModel.fromJson(firstItem);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> savePressReport(Map<String, dynamic> reportData) async {
    await dio.post('/full-press-reports', data: reportData);
  }

  @override
  Future<List<String>> getAllSeries() async {
    final response = await dio.get('/presses/');
    if (response.data is List) {
      return (response.data as List).map((p) => p['serie'].toString()).toList();
    }
    return [];
  }
}

