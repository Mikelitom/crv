// lib/features/servicios/data/repositories/service_repository_impl.dart
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/data/datasource/v_service_datasource.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/v_service_order.dart';
import '../../domain/repositories/v_service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceDataSource remoteDataSource;

  ServiceRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ServiceOrder>>> getServicesByVehicle(String vehicleId) async {
    try {
      final models = await remoteDataSource.getServicesByVehicle(vehicleId);
      return Right(models); // Retorna la lista de entidades
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error de conexión'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}