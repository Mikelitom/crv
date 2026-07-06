// lib/features/servicios/data/repositories/press_service_repository_impl.dart
import 'package:crv_reprosisa/features/servicios/domain/repositories/press_service_repository.dart';
import 'package:crv_reprosisa/features/servicios/data/datasource/press_service_datasource.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/press_service_item_entity.dart';

class PressServiceRepositoryImpl implements PressServiceRepository {
  final PressServiceDataSource dataSource;

  PressServiceRepositoryImpl(this.dataSource);

  @override
  Future<List<PressServiceItemEntity>> getServiceItems(String serviceId) async {
    try {
      final models = await dataSource.getServiceItems(serviceId);
      return models; // Como PressServiceItemModel extiende de la Entidad, es compatible
    } catch (e) {
      throw Exception("Error en repositorio al obtener ítems: $e");
    }
  }
}
