import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/create_service_order_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CreateServiceRepository {
Future<Either<Failure, String>> createService(CreateServiceOrderEntity entity);}