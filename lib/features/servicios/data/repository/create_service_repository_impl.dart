// lib/features/servicios/data/repository/create_service_repository_impl.dart
import 'package:crv_reprosisa/features/servicios/data/models/vehiculos/create_service_order_model.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/create_service_order_entity.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/create_service_repository.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CreateServiceRepositoryImpl implements CreateServiceRepository {
  final Dio dio;

  CreateServiceRepositoryImpl(this.dio);

  @override
  // IMPORTANTE: Aquí declaramos que devuelve String, NO void.
  Future<Either<Failure, String>> createService(CreateServiceOrderEntity entity) async {
    try {
      final model = CreateServiceOrderModel(
        vehicleId: entity.vehicleId,
        description: entity.description,
        observation: entity.observation,
        serviceItems: entity.serviceItems,
      );

      final response = await dio.post(
        '/vehicle/service', 
        data: model.toJson(),
      );
      
      final String orderNumber = response.data['order_number'].toString(); 
      
      return Right(orderNumber);
      
    } on DioException catch (e) {
      debugPrint("Error al crear servicio: ${e.response?.data}");
      final errorMessage = e.response?.data?['detail']?.toString() ?? e.message ?? 'Error de conexión';
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}