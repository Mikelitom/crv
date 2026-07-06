// lib/features/servicios/domain/repositories/create_press_service_repository.dart
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/press_create_order_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CreatePressServiceRepository {
  Future<Either<Failure, String>> createService(PressCreateOrderEntity entity);
}