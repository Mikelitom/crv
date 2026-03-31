import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/catalogo_repositories.dart';

class UpdateVehicleStatusUseCase {
  final CatalogoRepository repository;
  UpdateVehicleStatusUseCase(this.repository);
  Future<Either<Failure, Unit>> call({required String id, required bool isActive}) => 
    repository.updateVehicleStatus(id: id, isActive: isActive);
}