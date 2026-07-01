// lib/features/servicios/domain/usecases/get_press_incidence_summary_usecase.dart
import 'package:crv_reprosisa/features/servicios/domain/repositories/press_incidence_repoitory.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/press_incidence_entity.dart';

class GetPressIncidenceSummaryUseCase {
  final PressIncidenceRepository repository;

  GetPressIncidenceSummaryUseCase(this.repository);

  Future<Either<Failure, List<PressIncidenceEntity>>> call(String pressId) async {
    return await repository.getIncidenceSummary(pressId);
  }
}