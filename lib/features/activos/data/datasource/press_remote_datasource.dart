import 'package:crv_reprosisa/features/activos/data/models/press_model.dart';
import 'package:crv_reprosisa/features/activos/domain/params/create_press_params.dart';

abstract class PressRemoteDatasource {
  Future<PressModel> createPress(CreatePressParams params);
  Future<List<PressModel>> getAllPress();
}
