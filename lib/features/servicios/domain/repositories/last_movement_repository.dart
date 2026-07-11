import 'package:crv_reprosisa/features/servicios/data/models/last_movements_model.dart';

abstract class DashboardRepository {
  Future<DashboardLastMovements> getLastMovements();
}