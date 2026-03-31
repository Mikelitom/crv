import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/press_loan_model.dart';
import '../repositories/catalogo_repositories.dart';

class GetPressesUseCase {
  final CatalogoRepository repository;
  GetPressesUseCase(this.repository);

  Future<Either<Failure, List<PressLoanModel>>> call() => repository.getPresses();
}