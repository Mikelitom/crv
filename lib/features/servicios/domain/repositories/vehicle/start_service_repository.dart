import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class StartServiceRepository {
  Future<Either<Failure, void>> startService(String serviceId);
}
