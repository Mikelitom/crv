import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/inspeccion_repository.dart';

class GetLatestLoanStatusUseCase {
  final InspeccionRepository repository;

  GetLatestLoanStatusUseCase(this.repository);

  Future<Either<Failure, String>> call(String pressId) async {
    return await repository.getLatestLoanStatus(pressId);
  }
}