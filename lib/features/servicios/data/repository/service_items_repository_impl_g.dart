import 'package:crv_reprosisa/features/servicios/data/datasource/v_service_datasource.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/incidence_repository_g.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/incidence_entity.dart';

class IncidenceRepositoryImplG implements IncidenceRepository {
  final ServiceDataSource remoteDataSource;

  IncidenceRepositoryImplG(this.remoteDataSource);

  @override
  Future<Either<Failure, List<IncidenceEntity>>> getIncidenceSummary(String vehicleId) async {
    try {
      // Llamamos al método definido en el DataSource
      final remoteIncidences = await remoteDataSource.getIncidenceSummary(vehicleId);
      return Right(remoteIncidences);
    } catch (e) {
      // Mapeo consistente del error
      return Left(ServerFailure(e.toString()));
    }
  }
}