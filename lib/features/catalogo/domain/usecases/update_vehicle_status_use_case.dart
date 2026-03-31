import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/catalogo_repositories.dart';

class UpdateVehicleStatusUseCase {
  final CatalogoRepository repository;

  UpdateVehicleStatusUseCase(this.repository);

  // Usamos parámetros nombrados para que coincida con el contrato del repositorio
  Future<Either<Failure, Unit>> call({
    required String id, 
    required bool isActive,
  }) async {
    return await repository.updateVehicleStatus(
      id: id, 
      isActive: isActive,
    );
  }
}