// lib/features/servicios/data/repositories/press_incidence_repository_impl.dart
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/data/datasource/press_service_datasource.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/press_incidence_entity.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/press_incidence_repoitory.dart';
import 'package:dartz/dartz.dart';

class PressIncidenceRepositoryImpl implements PressIncidenceRepository {
  final PressServiceDataSource remoteDataSource;

  PressIncidenceRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PressIncidenceEntity>>> getIncidenceSummary(String pressId) async {
    try {
      final result = await remoteDataSource.getIncidenceSummary(pressId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}