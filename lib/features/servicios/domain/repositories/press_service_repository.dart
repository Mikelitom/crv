// lib/features/servicios/domain/repositories/press_service_repository.dart
import 'package:crv_reprosisa/features/servicios/domain/entities/press_service_item_entity.dart';

abstract class PressServiceRepository {
  Future<List<PressServiceItemEntity>> getServiceItems(String serviceId);
}