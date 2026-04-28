import 'package:dio/dio.dart';
import '../models/press_model.dart';

abstract class InspeccionRemoteDataSource {
  Future<PressModel?> getPressBySerie(String serie);
  Future<String> savePressReport(Map<String, dynamic> reportData);
  Future<List<String>> getAllSeries();
  Future<List<dynamic>> getInspectionTemplate();
  
  Future<List<dynamic>> getAllLoanAreas();
  Future<Map<String, dynamic>> createLoanArea(Map<String, String> areaData);
  Future<void> createLoan(Map<String, dynamic> loanData);
}

class InspeccionRemoteDataSourceImpl implements InspeccionRemoteDataSource {
  final Dio dio;
  InspeccionRemoteDataSourceImpl(this.dio);

  @override
  Future<List<dynamic>> getInspectionTemplate() async {
    try {
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
  Future<String> savePressReport(Map<String, dynamic> reportData) async {
    final response = await dio.post('/full-press-reports', data: reportData);
    return response.data['id'].toString();
  }

  @override
  Future<List<String>> getAllSeries() async {
    final response = await dio.get('/presses/');
    if (response.data is List) {
      return (response.data as List).map((p) => p['serie'].toString()).toList();
    }
    return [];
  }

  @override
  Future<List<dynamic>> getAllLoanAreas() async {
    final response = await dio.get('/loan-area/active');
    if (response.data is List) return response.data;
    if (response.data != null) return [response.data];
    return [];
  }

  @override
  Future<Map<String, dynamic>> createLoanArea(Map<String, String> areaData) async {
    final response = await dio.post('/loan-area/', data: areaData);
    return response.data;
  }

  @override
  Future<void> createLoan(Map<String, dynamic> loanData) async {
    await dio.post('/loans/', data: loanData);
  }
}