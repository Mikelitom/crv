// lib/features/servicios/data/repositories/press_service_order_repository_impl.dart
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/data/datasource/press_service_datasource.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/press_service_order_entity.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/press_service_order_repository.dart';
import 'package:dartz/dartz.dart';

class PressServiceOrderRepositoryImpl implements PressServiceOrderRepository {
  final PressServiceDataSource remoteDataSource;

  PressServiceOrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PressServiceOrderEntity>>> getServiceOrders(String pressId) async {
    try {
      final result = await remoteDataSource.getServiceOrders(pressId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}