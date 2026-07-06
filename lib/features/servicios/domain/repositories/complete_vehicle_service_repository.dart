import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class CompleteVehicleServiceRepository {
  Future<Either<Failure, bool>> completeService(String serviceId);
}
