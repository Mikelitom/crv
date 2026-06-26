import 'package:crv_reprosisa/features/servicios/data/models/v_service_order_model.dart';
import 'package:dio/dio.dart';

abstract class ServiceDataSource {
  Future<List<ServiceOrderModel>> getServicesByVehicle(String vehicleId);
}

class ServiceDataSourceImpl implements ServiceDataSource {
  final Dio dio;

  ServiceDataSourceImpl(this.dio);

  @override
  Future<List<ServiceOrderModel>> getServicesByVehicle(String vehicleId) async {
    final response = await dio.get(
      '/vehicle/service/$vehicleId',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => ServiceOrderModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener servicios');
    }
  }
}
