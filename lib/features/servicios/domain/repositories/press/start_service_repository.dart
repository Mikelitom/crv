import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class StartPressServiceRepository {
  Future<Either<Failure, Unit>> startService({required String serviceId, required String observation});
}
