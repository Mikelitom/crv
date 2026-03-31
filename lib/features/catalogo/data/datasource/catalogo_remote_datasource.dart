import 'package:dartz/dartz.dart';
import '../models/press_loan_model.dart';
import '../models/vehicle_state_model.dart';

abstract class CatalogoRemoteDataSource {
  Future<List<VehicleStateModel>> getVehicles();
  Future<List<PressLoanModel>> getPresses();
  
  Future<Unit> updateVehicleStatus(String id, bool isActive);
  Future<Unit> updatePressStatus(String id, bool isActive);
  Future<Unit> deleteVehicle(String id);
  Future<Unit> deletePress(String id);
}