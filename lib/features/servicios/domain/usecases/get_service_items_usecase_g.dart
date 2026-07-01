import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
// Asegúrate de que estos imports coincidan con tu estructura de archivos
import '../entities/incidence_entity.dart';
import '../repositories/incidence_repository_g.dart'; 

class GetIncidenceSummaryUseCaseG {
  final IncidenceRepository repository;

  GetIncidenceSummaryUseCaseG(this.repository);

  // Método call para ejecutar la lógica
  Future<Either<Failure, List<IncidenceEntity>>> call(String vehicleId) async {
    return await repository.getIncidenceSummary(vehicleId);
  }
}