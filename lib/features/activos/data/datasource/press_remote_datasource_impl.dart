import 'package:crv_reprosisa/features/activos/data/datasource/press_remote_datasource.dart';
import 'package:crv_reprosisa/features/activos/data/models/press_model.dart';
import 'package:crv_reprosisa/features/activos/domain/params/create_press_params.dart';
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
        "serie": params.serie,
        "size": params.size,
      },
    );

    return PressModel.fromJson(response.data);
  }

  @override
  Future<List<PressModel>> getAllPress() async {
    final response = await dio.get("/presses/");

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response.data,
    );

    return data.map(PressModel.fromJson).toList();
  }
}
