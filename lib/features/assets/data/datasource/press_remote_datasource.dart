import 'package:crv_reprosisa/features/assets/data/models/press_model.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_press_params.dart';
import 'package:crv_reprosisa/features/assets/data/models/press_history_model.dart';
import 'package:crv_reprosisa/features/assets/data/models/press_report_detail_model.dart';


abstract class PressRemoteDatasource {
  Future<PressModel> createPress(CreatePressParams params);
  Future<PressModel> updatePress(String id, CreatePressParams params);
  Future<List<PressModel>> getAllPress();
  Future<void> activatePress(String id);
  Future<void> deactivatePress(String id);
  Future<List<PressHistoryModel>> getPressHistory(String pressId);
  Future<PressReportDetailModel> getPressReportDetail(String versionId);
}
