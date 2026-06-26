import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/v_service_order.dart';
import 'package:dartz/dartz.dart';

abstract class ServiceRepository {
  Future<Either<Failure, List<ServiceOrder>>> getServicesByVehicle(String vehicleId);
}