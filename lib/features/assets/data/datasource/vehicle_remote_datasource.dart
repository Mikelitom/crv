import 'package:crv_reprosisa/features/assets/data/models/vehicle_model.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_vehicle_params.dart';
import 'package:crv_reprosisa/features/assets/data/models/vehicle_history_model.dart';
import '../models/vehicle_report_detail_model.dart';

abstract class VehicleRemoteDatasource {
  Future<VehicleModel> createVehicle(CreateVehicleParams params);
  Future<VehicleModel> updateVehicle(String id, CreateVehicleParams params);
  Future<List<VehicleModel>> getAllVehicle();
  Future<void> activateVehicle(String id);
  Future<void> deactivateVehicle(String id);
  Future<List<VehicleHistoryModel>> getVehicleHistory(String vehicleId);
  Future<VehicleReportDetailModel> getVehicleReportDetail(String versionId);  }
