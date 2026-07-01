// lib/features/servicios/domain/entities/attach_items_entity.dart
class AttachItemsEntity {
  final String serviceId;
  final List<String> itemIds;

  const AttachItemsEntity({
    required this.serviceId,
    required this.itemIds,
  });
}