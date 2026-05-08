import 'package:crv_reprosisa/features/catalogo/data/models/vehicle_catalog_model.dart';
import 'package:dartz/dartz.dart';
import '../models/press_loan_model.dart';

abstract class CatalogoRemoteDataSource {
  Future<List<VehicleCatalogModel>> getVehicles();
  Future<List<PressLoanModel>> getPresses();

  Future<Unit> updateVehicleStatus(String id, bool isActive);
  Future<Unit> updatePressStatus(String id, bool isActive);
  Future<Unit> deleteVehicle(String id);
  Future<Unit> deletePress(String id);
}

