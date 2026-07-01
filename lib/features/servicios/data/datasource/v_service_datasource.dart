import 'package:crv_reprosisa/features/servicios/data/models/v_service_order_model.dart';
import 'package:crv_reprosisa/features/servicios/data/models/vehiculos/attach_item_model.dart';
import 'package:crv_reprosisa/features/servicios/data/models/vehiculos/create_service_order_model.dart';
import 'package:crv_reprosisa/features/servicios/data/models/vehiculos/incidence_model.dart';
import 'package:crv_reprosisa/features/servicios/data/models/vehiculos/service_item_model.dart';
import 'package:dio/dio.dart';

abstract class ServiceDataSource {
  Future<void> attachItems(String serviceId, AttachItemsModel model);
  Future<List<ServiceOrderModel>> getServicesByVehicle(String vehicleId);
  Future<List<ServiceItemModel>> getServiceItems(String serviceId);
  Future<void> createService(CreateServiceOrderModel model);
  Future<List<IncidenceModel>> getIncidenceSummary(String vehicleId);
  Future<List<ServiceOrderModel>> getPendingServicesByVehicle(String vehicleId);
}

class ServiceDataSourceImpl implements ServiceDataSource {
  final Dio dio;

  ServiceDataSourceImpl(this.dio);

  @override
  Future<List<ServiceOrderModel>> getServicesByVehicle(String vehicleId) async {
    final response = await dio.get('/vehicle/service/$vehicleId');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => ServiceOrderModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener servicios: ${response.statusCode}');
    }
  }

  @override
  Future<void> createService(CreateServiceOrderModel model) async {
    final response = await dio.post('/vehicle/service', data: model.toJson());

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear la orden: ${response.statusCode}');
    }
  }

  @override
  Future<List<ServiceOrderModel>> getPendingServicesByVehicle(
    String vehicleId,
  ) async {
    final response = await dio.get(
      '/vehicle/service/vehicle/$vehicleId/pending-items',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => ServiceOrderModel.fromJson(json)).toList();
    } else {
      throw Exception(
        'Error al obtener servicios pendientes: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> attachItems(String serviceId, AttachItemsModel model) async {
    // La URL usa el serviceId como parámetro en el path
    final response = await dio.post(
      '/vehicle/service/$serviceId/items',
      data: model.toJson(),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al adjuntar ítems: ${response.statusCode}');
    }
  }

  @override
  Future<List<ServiceItemModel>> getServiceItems(String serviceId) async {
    final response = await dio.get(
      '/vehicle/service/service-items/$serviceId',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => ServiceItemModel.fromJson(json)).toList();
    } else {
      throw Exception(
        'Error al obtener ítems del servicio: ${response.statusCode}',
      );
    }
    
  }
  @override
  Future<List<IncidenceModel>> getIncidenceSummary(String vehicleId) async {
    // Implementación del nuevo endpoint
    final response = await dio.get('/vehicle/service/vehicles/$vehicleId/incidence-summary');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => IncidenceModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener resumen de incidencias: ${response.statusCode}');
    }
  }
}
