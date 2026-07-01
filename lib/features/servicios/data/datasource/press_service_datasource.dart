// lib/features/assets/data/datasource/press_service_datasource.dart
import 'package:crv_reprosisa/features/servicios/data/models/press/press_incidence_entity.dart';
import 'package:crv_reprosisa/features/servicios/data/models/press/press_item_model.dart';
import 'package:crv_reprosisa/features/servicios/data/models/press/press_service_order_model.dart';
import 'package:dio/dio.dart';

abstract class PressServiceDataSource {
  Future<List<PressItemModel>> getPendingItems(String pressId);
  Future<List<PressIncidenceModel>> getIncidenceSummary(String pressId); 
  Future<List<PressServiceOrderModel>> getServiceOrders(String pressId);
}

class PressServiceDataSourceImpl implements PressServiceDataSource {
  final Dio dio;
  PressServiceDataSourceImpl(this.dio);

  @override
  Future<List<PressItemModel>> getPendingItems(String pressId) async {
    final response = await dio.get('/press/service/press/$pressId/pending-items');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => PressItemModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener componentes pendientes de prensa');
    }
  }
  @override
  Future<List<PressIncidenceModel>> getIncidenceSummary(String pressId) async {
    final response = await dio.get('/press/service/press/$pressId/incidence-summary');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => PressIncidenceModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener el resumen de incidencias');
    }
  }
  @override
  Future<List<PressServiceOrderModel>> getServiceOrders(String pressId) async {
    final response = await dio.get('/press/service/press/$pressId');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => PressServiceOrderModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener órdenes de servicio');
    }
  }
}