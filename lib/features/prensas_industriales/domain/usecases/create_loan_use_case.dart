import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/inspeccion_repository.dart';

class CreateLoanUseCase {
  final InspeccionRepository repository;

  CreateLoanUseCase(this.repository);

  Future<Either<Failure, Unit>> call(Map<String, dynamic> loanData) async {
    return await repository.createLoan(loanData);
  }
}