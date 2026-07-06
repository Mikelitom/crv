// lib/features/servicios/data/repository/create_press_service_repository_impl.dart
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/servicios/data/datasource/press_service_datasource.dart';
import 'package:crv_reprosisa/features/servicios/data/models/press/press_create_order_model.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/press_create_order_entity.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/create_press_service_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CreatePressServiceRepositoryImpl implements CreatePressServiceRepository {
  final PressServiceDataSource dataSource;

  CreatePressServiceRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, String>> createService(PressCreateOrderEntity entity) async {
    try {
      final model = PressCreateOrderModel(
        pressId: entity.pressId,
        description: entity.description,
        observation: entity.observation,
        serviceItems: entity.serviceItems,
      );

      // Llamamos al método del DataSource
      await dataSource.createServiceOrder(model);
      
      // Asumimos que el backend devuelve éxito. 
      // Si el backend devuelve un ID, ajusta el DataSource para retornar el response.data
      return const Right("Orden Creada Exitosamente");
      
    } on DioException catch (e) {
      debugPrint("Error al crear servicio de prensa: ${e.response?.data}");
      final errorMessage = e.response?.data?['detail']?.toString() ?? e.message ?? 'Error de conexión';
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}