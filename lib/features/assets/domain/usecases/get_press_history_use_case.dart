import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/press_history.dart';
import '../repositories/press_repository.dart';

class GetPressHistoryUseCase {
  final PressRepository repository;

  GetPressHistoryUseCase(this.repository);

  Future<Either<Failure, List<PressHistory>>> call(String pressId) async {
    return await repository.getPressHistory(pressId);
  }
}