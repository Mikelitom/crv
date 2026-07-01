import 'package:crv_reprosisa/features/servicios/data/models/v_service_order_model.dart'; // O tu modelo correspondiente
import 'package:crv_reprosisa/features/servicios/data/models/vehiculos/pending_component_entity_v.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/pending_component_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/pending_component_entity_v.dart';

class PendingComponentRepositoryImpl implements IPendingComponentRepository {
  final Dio dio;
  PendingComponentRepositoryImpl(this.dio);

  @override
  Future<Either<String, List<PendingComponentEntityV>>> getPendingComponents(String vehicleId) async {
    try {
      final response = await dio.get('/vehicle/service/vehicle/$vehicleId/pending-items');
      
      final List<dynamic> data = response.data;
      
      // Mapeamos a tu modelo (asegúrate de que PendingComponentModelV esté importado arriba)
      final components = data.map((e) => PendingComponentModelV.fromJson(e)).toList();
      
      return Right(components);
    } catch (e) {
      return Left("Error al obtener componentes pendientes: ${e.toString()}");
    }
  }
}