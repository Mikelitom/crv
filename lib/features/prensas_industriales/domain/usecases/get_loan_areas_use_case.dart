import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/loan_area.dart';
import '../repositories/inspeccion_repository.dart';

class GetLoanAreasUseCase {
  final InspeccionRepository repository;
  GetLoanAreasUseCase(this.repository);

  Future<Either<Failure, List<LoanArea>>> call() async {
    return await repository.getLoanAreas();
  }
}