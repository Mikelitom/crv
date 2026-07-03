// lib/features/servicios/domain/repositories/press_service_order_repository.dart
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/press_service_order_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PressServiceOrderRepository {
  Future<Either<Failure, List<PressServiceOrderEntity>>> getServiceOrders(String pressId);
}