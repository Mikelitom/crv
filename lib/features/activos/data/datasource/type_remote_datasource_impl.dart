import 'package:crv_reprosisa/features/activos/data/datasource/type_remote_datasource.dart';
import 'package:crv_reprosisa/features/activos/data/models/vehicle_types_model.dart';
import 'package:crv_reprosisa/features/activos/domain/entities/vehicle_type.dart';
import 'package:dio/dio.dart';

class TypeRemoteDatasourceImpl implements TypeRemoteDatasource {
  final Dio dio;

  TypeRemoteDatasourceImpl(this.dio);

  @override
  Future<List<VehicleType>> getAllTypes() async {
    final response = await dio.get("/vehicle-types/");

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response.data,
    );

    return data.map(VehicleTypesModel.fromJson).toList();
  }
}
