import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/inspeccion_repository.dart';

class GetLoanAreasUseCase {
  final InspeccionRepository repository;
  GetLoanAreasUseCase(this.repository);

  Future<Either<Failure, List<dynamic>>> call() async {
    return await repository.getLoanAreas();
  }
}