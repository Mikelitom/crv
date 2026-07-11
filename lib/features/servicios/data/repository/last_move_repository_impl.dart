import 'package:crv_reprosisa/features/servicios/data/datasource/last_move_datasource.dart';
import 'package:crv_reprosisa/features/servicios/data/models/last_movements_model.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/last_movement_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {

  final DashboardRemoteDataSource remote;

  DashboardRepositoryImpl(this.remote);

  @override
  Future<DashboardLastMovements> getLastMovements() {
    return remote.getLastMovements();
  }
}