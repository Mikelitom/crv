import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/client_mine.dart';
import '../repositories/banda_repository.dart';

class GetActiveMinesUseCase {
  final BandaRepository repository;
  GetActiveMinesUseCase(this.repository);

  Future<Either<Failure, List<Mine>>> call() async {
    return await repository.getActiveMines();
  }
}