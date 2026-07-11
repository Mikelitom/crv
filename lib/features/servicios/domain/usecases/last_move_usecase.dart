import 'package:crv_reprosisa/features/servicios/data/models/last_movements_model.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/last_movement_repository.dart';

class GetLastMovementsUseCase {

  final DashboardRepository repository;

  GetLastMovementsUseCase(this.repository);

  Future<DashboardLastMovements> call() {
    return repository.getLastMovements();
  }
}