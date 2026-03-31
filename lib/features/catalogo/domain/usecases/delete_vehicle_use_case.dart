import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/catalogo_repositories.dart';

class DeleteVehicleUseCase {
  final CatalogoRepository repository;
  DeleteVehicleUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteVehicle(id);
  }
}