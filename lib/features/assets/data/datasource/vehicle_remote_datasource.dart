import 'package:crv_reprosisa/features/assets/data/models/vehicle_model.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_vehicle_params.dart';

abstract class VehicleRemoteDatasource {
  Future<VehicleModel> createVehicle(CreateVehicleParams params);
  Future<VehicleModel> updateVehicle(String id, CreateVehicleParams params);
  Future<List<VehicleModel>> getAllVehicle();
}
