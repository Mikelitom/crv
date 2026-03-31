import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import '../../data/models/vehicle_state_model.dart'; 
import '../../data/models/press_loan_model.dart';

abstract class CatalogoRepository {
  Future<Either<Failure, List<VehicleStateModel>>> getVehicles();
  Future<Either<Failure, List<PressLoanModel>>> getPresses();

  Future<Either<Failure, Unit>> updateVehicleStatus({required String id, required bool isActive});
  Future<Either<Failure, Unit>> updatePressStatus({required String id, required bool isActive});
  Future<Either<Failure, Unit>> deleteVehicle(String id);
  Future<Either<Failure, Unit>> deletePress(String id);
}