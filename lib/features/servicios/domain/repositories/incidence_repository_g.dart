import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/incidence_entity.dart';

abstract class IncidenceRepository {
  Future<Either<Failure, List<IncidenceEntity>>> getIncidenceSummary(String vehicleId);
}