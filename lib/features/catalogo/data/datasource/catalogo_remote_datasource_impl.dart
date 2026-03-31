import 'package:crv_reprosisa/features/catalogo/data/models/vehicle_state_model.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import './catalogo_remote_datasource.dart';
import '../models/press_loan_model.dart';

class CatalogoRemoteDataSourceImpl implements CatalogoRemoteDataSource {
  final Dio dio;
  CatalogoRemoteDataSourceImpl(this.dio);

  @override
  Future<List<VehicleStateModel>> getVehicles() async {
    final response = await dio.get("/vehicle_full_state/"); 
    return (response.data as List)
        .map((json) => VehicleStateModel.fromJson(json))
        .toList();
  }
@override
Future<List<PressLoanModel>> getPresses() async {
  final response = await dio.get("loans/"); 
  
  if (response.data != null && response.data is List) {
    return (response.data as List)
        .map((json) => PressLoanModel.fromJson(json))
        .toList();
  }
  return [];
}

  @override
  Future<Unit> updateVehicleStatus(String id, bool isActive) async {
    await dio.patch(
      "/activos/vehicles/$id",
      data: {'is_active': isActive},
    );
    return unit;
  }

  @override
  Future<Unit> updatePressStatus(String id, bool isActive) async {
    await dio.patch(
      "/activos/presses/$id",
      data: {'is_active': isActive},
    );
    return unit;
  }

  @override
  Future<Unit> deleteVehicle(String id) async {
    await dio.delete("/activos/vehicles/$id");
    return unit;
  }

  @override
  Future<Unit> deletePress(String id) async {
    await dio.delete("/activos/presses/$id");
    return unit;
  }
}