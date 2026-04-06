import 'package:crv_reprosisa/features/assets/data/models/press_model.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_press_params.dart';

abstract class PressRemoteDatasource {
  Future<PressModel> createPress(CreatePressParams params);
  Future<PressModel> updatePress(String id, CreatePressParams params);
  Future<List<PressModel>> getAllPress();
}
