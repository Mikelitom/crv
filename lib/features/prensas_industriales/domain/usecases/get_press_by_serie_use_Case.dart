import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/entities_press.dart';
import '../repositories/inspeccion_repository.dart';

class GetPressBySerieUseCase {
  final InspeccionRepository repository;
  GetPressBySerieUseCase(this.repository);

  Future<Either<Failure, Press>> call(String serie) async {
    return await repository.getPressBySerie(serie);
  }
}