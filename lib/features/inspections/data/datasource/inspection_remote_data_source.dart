import 'package:dio/dio.dart';
import '../../presentation/models/inspector_row_ui.dart';

abstract class InspectionRemoteDataSource {
  Future<List<InspectionRowUI>> getMyInspections();
  Future<Map<String, dynamic>> getInspectionById(String id);
}

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
  Future<Map<String, dynamic>> getInspectionById(String id) async {
    final response = await dio.get('/catalog/$id'); 
    return response.data as Map<String, dynamic>;
  }
}