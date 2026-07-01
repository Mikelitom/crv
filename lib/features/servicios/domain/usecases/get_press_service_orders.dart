// lib/features/servicios/domain/usecases/get_press_service_orders_usecase.dart
import 'package:crv_reprosisa/features/servicios/domain/entities/press_service_order_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/press_service_order_entity.dart';

class GetPressServiceOrdersUseCase {
  final PressServiceOrderRepository repository;

  GetPressServiceOrdersUseCase(this.repository);

  Future<Either<Failure, List<PressServiceOrderEntity>>> call(String pressId) async {
    return await repository.getServiceOrders(pressId);
  }
}