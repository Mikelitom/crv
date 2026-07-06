import 'package:crv_reprosisa/features/servicios/domain/entities/press_attach_item_entity.dart';

class PressAttachItemModel extends PressAttachItemEntity {
  const PressAttachItemModel({
    required super.serviceId,
    required super.itemIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_ids': itemIds,
    };
  }

  factory PressAttachItemModel.fromEntity(PressAttachItemEntity entity) {
    return PressAttachItemModel(
      serviceId: entity.serviceId,
      itemIds: entity.itemIds,
    );
  }
}