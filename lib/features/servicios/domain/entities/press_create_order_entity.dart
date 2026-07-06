// lib/features/servicios/domain/entities/press_create_order_entity.dart
class PressCreateOrderEntity {
  final String pressId;
  final String description;
  final String observation;
  final List<String> serviceItems;

  const PressCreateOrderEntity({
    required this.pressId,
    required this.description,
    required this.observation,
    required this.serviceItems,
  });
}