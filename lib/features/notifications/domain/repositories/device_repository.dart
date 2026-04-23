import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/notifications/domain/entities/device.dart';
import 'package:dartz/dartz.dart';

abstract class DeviceRepository {
  Future<Either<Failure, void>> registerDevice(Device device);
}
