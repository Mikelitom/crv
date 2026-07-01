import 'package:dartz/dartz.dart';
import '../../domain/entities/pending_component_entity_v.dart';

abstract class IPendingComponentRepository {
  Future<Either<String, List<PendingComponentEntityV>>> getPendingComponents(String vehicleId);
}