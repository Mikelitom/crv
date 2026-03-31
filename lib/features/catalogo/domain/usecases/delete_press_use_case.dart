import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/catalogo_repositories.dart';

class DeletePressUseCase {
  final CatalogoRepository repository;
  DeletePressUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String id) {
    return repository.deletePress(id);
  }
}