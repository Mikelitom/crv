// lib/features/servicios/domain/repositories/press_incidence_repository.dart
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/press_incidence_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PressIncidenceRepository {
  Future<Either<Failure, List<PressIncidenceEntity>>> getIncidenceSummary(String pressId);
}