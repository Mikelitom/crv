// lib/features/assets/data/datasource/press_remote_datasource_impl.dart
import 'package:crv_reprosisa/features/assets/data/datasource/press_remote_datasource.dart';
import 'package:crv_reprosisa/features/assets/data/models/press_model.dart';
import 'package:crv_reprosisa/features/assets/data/models/press_history_model.dart';
import 'package:crv_reprosisa/features/assets/data/models/press_report_detail_model.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_press_params.dart';
import 'package:dio/dio.dart';

class PressRemoteDatasourceImpl implements PressRemoteDatasource {
  final Dio dio;

  PressRemoteDatasourceImpl(this.dio);

  @override
  Future<PressModel> createPress(CreatePressParams params) async {
    final response = await dio.post(
      '/presses/',
      data: {
        "type": params.type,
        "model": params.model,
        "voltz": params.voltz,
        "serie": params.serie.toUpperCase(),
        "size": params.size,
      },
    );

    return PressModel.fromJson(response.data);
  }

  @override
  Future<PressModel> updatePress(String id, CreatePressParams params) async {
    print("DEBUG: Intentando PUT a: /api/v1/presses/$id");

    if (id.isEmpty || id == "null") {
      throw Exception("El ID de la prensa es nulo o vacío");
    }
    
    final response = await dio.put(
      '/presses/$id',
      data: {
        "type": params.type,
        "model": params.model,
        "voltz": params.voltz,
        "serie": params.serie.toUpperCase(),
        "size": params.size,
      },
    );

    return PressModel.fromJson(response.data);
  }

  @override
  Future<void> activatePress(String id) async {
    await dio.patch("/presses/restore/$id");
  }

  @override
  Future<void> deactivatePress(String id) async {
    await dio.delete("/presses/$id");
  }

  @override
  Future<List<PressModel>> getAllPress() async {
    final response = await dio.get("/asset/press");

    final List<dynamic> data = response.data;
    
    return data.map((json) => PressModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<PressHistoryModel>> getPressHistory(String pressId) async {
    final response = await dio.get("/asset/press-history", queryParameters: {"press_id": pressId});
    return (response.data as List).map((json) => PressHistoryModel.fromJson(json)).toList();
  }


@override
Future<PressReportDetailModel> getPressReportDetail(String versionId) async {
  // AJUSTE: Si tu API sigue el estándar de 'conveyor', la ruta es esta:
  final response = await dio.get('/asset/press/$versionId'); 
  
  
  return PressReportDetailModel.fromJson(response.data);
}
}