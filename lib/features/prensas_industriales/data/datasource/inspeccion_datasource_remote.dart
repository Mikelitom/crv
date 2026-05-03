import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../models/press_model.dart';
import '../models/loan_area_model.dart';

abstract class InspeccionRemoteDataSource {
  Future<PressModel?> getPressBySerie(String serie);
  Future<String> savePressReport(Map<String, dynamic> reportData);
  Future<List<String>> getAllSeries();
  Future<List<dynamic>> getInspectionTemplate();
  Future<List<dynamic>> getAllLoanAreas();
  Future<Map<String, dynamic>> createLoanArea(Map<String, String> areaData);
  Future<void> createLoan(Map<String, dynamic> loanData);
  
  // 1. Declarar el método en la interfaz para que sea visible
  Future<Uint8List> getInspectionPdfFile(String id);
  
  // 2. Declarar el método de filtros para el estado de la prensa
  Future<List<dynamic>> getLoansMultiFilter(Map<String, dynamic> body);
}

class InspeccionRemoteDataSourceImpl implements InspeccionRemoteDataSource {
  final Dio dio;
  InspeccionRemoteDataSourceImpl(this.dio);

  @override
  Future<List<dynamic>> getLoansMultiFilter(Map<String, dynamic> body) async {
    // POST /api/v1/loans/multi-filter según imagen_80.png
    final response = await dio.post(
      '/loans/multi-filter',
      queryParameters: {
        'limit': 1,
        'offset': 0,
        'order_by': 'created_at',
        'descending': true,
      },
      data: body,
    );
    return response.data as List<dynamic>;
  }

  @override
  Future<Uint8List> getInspectionPdfFile(String id) async {
    try {
      final response = await dio.get(
        '/reports/pdf/$id',
        options: Options(
          responseType: ResponseType.bytes, 
          headers: {'Accept': 'application/pdf'},
        ),
      );
      
      if (response.headers.value('content-type') == 'application/pdf' || 
          response.data is Uint8List) {
        return Uint8List.fromList(response.data);
      }
      
      throw Exception("El servidor no retornó un archivo PDF válido");
    } catch (e) {
      rethrow;
    }
  }

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
    try {
      final response = await dio.get('/loan-area/active');
      if (response.data is List) return response.data as List<dynamic>;
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> createLoanArea(Map<String, String> areaData) async {
    final response = await dio.post('/loan-area/', data: areaData);
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> createLoan(Map<String, dynamic> loanData) async {
    await dio.post('/loans/', data: loanData);
  }
}