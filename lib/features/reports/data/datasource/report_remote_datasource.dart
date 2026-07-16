import 'package:crv_reprosisa/features/reports/data/models/conveyor_history_model.dart';
import 'package:crv_reprosisa/features/reports/data/models/press_history_model.dart';
import 'package:crv_reprosisa/features/reports/data/models/vehicle_history_model.dart';

abstract class ReportRemoteDatasource {
  Future<List<VehicleHistoryModel>> getVehicleHistory();
  Future<List<ConveyorHistoryModel>> getConveyorHistory();
  Future<List<PressHistoryModel>> getPressHistory(); // <-- SIN parámetros
}