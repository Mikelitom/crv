import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/vehicle_state_model.dart';
import '../repositories/catalogo_repositories.dart';

class GetVehiclesUseCase {
  final CatalogoRepository repository;
  GetVehiclesUseCase(this.repository);

  Future<Either<Failure, List<VehicleStateModel>>> call() => repository.getVehicles();
}