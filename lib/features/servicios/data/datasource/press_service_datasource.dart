// lib/features/assets/data/datasource/press_service_datasource.dart
import 'package:crv_reprosisa/features/servicios/data/models/press/press_attach_item_model.dart';
import 'package:crv_reprosisa/features/servicios/data/models/press/press_create_order_model.dart';
import 'package:crv_reprosisa/features/servicios/data/models/press/press_incidence_entity.dart';
import 'package:crv_reprosisa/features/servicios/data/models/press/press_item_model.dart';
import 'package:crv_reprosisa/features/servicios/data/models/press/press_service_item_model.dart';
import 'package:crv_reprosisa/features/servicios/data/models/press/press_service_order_model.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/service_evidence.dart';
import 'package:dio/dio.dart';

abstract class PressServiceDataSource {
  Future<List<PressItemModel>> getPendingItems(String pressId);
  Future<List<PressIncidenceModel>> getIncidenceSummary(String pressId);
  Future<List<PressServiceOrderModel>> getServiceOrders(String pressId);
  Future<void> createServiceOrder(PressCreateOrderModel order);
  Future<void> attachPressItems(String serviceId, PressAttachItemModel model);
  Future<List<PressServiceItemModel>> getServiceItems(String serviceId);
  Future<List<dynamic>> getPendingMaintenanceGlobal();
  Future<List<dynamic>> getLoansMultiFilter();
  Future<void> startService({
    required String serviceId,
    required String observation,
  });
  Future<bool> completeService(
    String serviceId,
    List<ServiceEvidence> evidences,
  );
}

class PressServiceDataSourceImpl implements PressServiceDataSource {
  final Dio dio;
  PressServiceDataSourceImpl(this.dio);

  @override
  Future<List<PressItemModel>> getPendingItems(String pressId) async {
    final response = await dio.get(
      '/press/service/press/$pressId/pending-items',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => PressItemModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener componentes pendientes de prensa');
    }
  }

  @override
  Future<List<PressIncidenceModel>> getIncidenceSummary(String pressId) async {
    final response = await dio.get(
      '/press/service/press/$pressId/incidence-summary',
    );
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

  @override
  Future<void> createServiceOrder(PressCreateOrderModel order) async {
    try {
      final response = await dio.post('/press/service', data: order.toJson());
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al crear la orden: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error en el DataSource al crear orden: $e');
    }
  }

  @override
  Future<void> attachPressItems(
    String serviceId,
    PressAttachItemModel model,
  ) async {
    try {
      final response = await dio.post(
        '/press/service/$serviceId/items',
        data: model.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al adjuntar ítems: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error en el DataSource al adjuntar ítems: $e');
    }
  }

  @override
  Future<List<PressServiceItemModel>> getServiceItems(String serviceId) async {
    final response = await dio.get('/press/service/service-items/$serviceId');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => PressServiceItemModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener ítems del servicio');
    }
  }

  // En tu PressServiceDataSourceImpl
  @override
  Future<List<dynamic>> getPendingMaintenanceGlobal() async {
    final response = await dio.post(
      '/press_service/multi-filter',
      data: {"status": "PENDING"},
    );

    if (response.statusCode == 200) {
      return response.data as List<dynamic>;
    } else {
      throw Exception(
        'Error al obtener mantenimientos pendientes: ${response.statusCode}',
      );
    }
  }

  // En tu PressServiceDataSourceImpl
  @override
  Future<List<dynamic>> getLoansMultiFilter() async {
    // El endpoint requiere un body vacío {}
    final response = await dio.post('/loans/multi-filter', data: {});

    if (response.statusCode == 200) {
      return response.data as List<dynamic>;
    } else {
      throw Exception('Error al obtener préstamos: ${response.statusCode}');
    }
  }

  @override
  Future<void> startService({
    required String serviceId,
    required String observation,
  }) async {
    final response = await dio.post(
      '/press/service/$serviceId/start',
      queryParameters: {"observation": observation},
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Error al iniciar servicio');
    }
  }

  @override
  Future<bool> completeService(
    String serviceId,
    List<ServiceEvidence> evidences,
  ) async {
    final response = await dio.patch(
      '/press/service/$serviceId/complete',
      data: {
        "evidences": evidences.map((evidence) => evidence.toJson()).toList(),
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al completar el servicio: ${response.statusCode}');
    }
  }
}
