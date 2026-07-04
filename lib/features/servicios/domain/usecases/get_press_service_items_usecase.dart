// lib/features/servicios/domain/usecases/get_press_service_items_usecase.dart
import 'package:crv_reprosisa/features/servicios/domain/entities/press_service_item_entity.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/press_service_repository.dart';

class GetPressServiceItemsUseCase {
  final PressServiceRepository repository;
  GetPressServiceItemsUseCase(this.repository);

  Future<List<PressServiceItemEntity>> call(String serviceId) async {
    return await repository.getServiceItems(serviceId);
  }
}