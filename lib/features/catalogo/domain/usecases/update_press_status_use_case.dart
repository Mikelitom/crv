import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/catalogo_repositories.dart';

class UpdatePressStatusUseCase {
  final CatalogoRepository repository;
  UpdatePressStatusUseCase(this.repository);

  Future<Either<Failure, Unit>> call({required String id, required bool isActive}) {
    return repository.updatePressStatus(id: id, isActive: isActive);
  }
}