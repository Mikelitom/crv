import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/features/servicios/data/models/vehiculos/maintenance_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
// Asegúrate de importar tus archivos correspondientes
import 'package:crv_reprosisa/features/servicios/domain/entities/maintenance_entity.dart';

final pendingMaintenanceProvider = FutureProvider<List<Maintenance>>((ref) async {
  final dio = ref.read(dioProvider); 
  
  try {
    // Realizamos la petición al endpoint
    final response = await dio.get(
      '/vehicle_service/filter',
      queryParameters: {
        'key_name': 'status',
        'key_value': 'PENDING',
      },
      options: Options(
        headers: {'Accept': 'application/json'},
      ),
    );

    // Verificamos que la respuesta sea una lista
    if (response.data is List) {
      final List<dynamic> data = response.data;
      
      // Mapeamos a MaintenanceModel (que extiende de Maintenance)
      return data.map((json) => MaintenanceModel.fromJson(json)).toList();
    } else {
      throw Exception("Formato de respuesta inesperado");
    }
    
  } on DioException catch (e) {
    // Manejo de errores de red
    throw Exception("Error al cargar mantenimientos: ${e.message}");
  } catch (e) {
    throw Exception("Ocurrió un error inesperado: $e");
  }
});