// lib/features/servicios/data/models/vehiculos/attach_items_model.dart
import 'package:crv_reprosisa/features/servicios/domain/entities/attach_item_entity.dart';


class AttachItemsModel extends AttachItemsEntity {
  const AttachItemsModel({
    required super.serviceId,
    required super.itemIds,
  });

  // El modelo es el único que sabe cómo convertirse a JSON
  Map<String, dynamic> toJson() {
    return {
      'item_ids': itemIds,
    };
  }

  // Factoría para crear un modelo a partir de la entidad
  factory AttachItemsModel.fromEntity(AttachItemsEntity entity) {
    return AttachItemsModel(
      serviceId: entity.serviceId,
      itemIds: entity.itemIds,
    );
  }
}