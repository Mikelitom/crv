import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/loan_area.dart';
import '../repositories/inspeccion_repository.dart';

class CreateLoanAreaUseCase {
  final InspeccionRepository repository;
  CreateLoanAreaUseCase(this.repository);

  Future<Either<Failure, LoanArea>> call(Map<String, String> data) async {
    return await repository.createLoanArea(data);
  }
}