import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/features/servicios/data/models/vehiculos/vehicle_state_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vehicleStateProvider = FutureProvider<List<VehicleStateModel>>((ref) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get('/vehicle_full_state/');

  if (response.statusCode == 200) {
    // Dio ya decodificó el JSON. response.data es la lista directamente.
    final List<dynamic> body = response.data; 

    return body.map<VehicleStateModel>((item) {
      print("Tipo de response.data: ${response.data.runtimeType}");
      return VehicleStateModel.fromJson(item as Map<String, dynamic>);
    }).toList();
  } else {
    throw Exception('Error al cargar datos');
  }
});