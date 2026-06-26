import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/v_service_order.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/v_service_repository.dart';
import 'package:dartz/dartz.dart';

class GetServicesByVehicle {
  final ServiceRepository repository;

  GetServicesByVehicle(this.repository);
  
  Future<Either<Failure, List<ServiceOrder>>> call(String vehicleId) => repository.getServicesByVehicle(vehicleId);
}
