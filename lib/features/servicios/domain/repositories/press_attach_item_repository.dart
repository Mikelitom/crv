import 'package:crv_reprosisa/features/servicios/domain/entities/press_attach_item_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

abstract class PressAttachItemRepository {
  Future<Either<Failure, void>> attachItems(PressAttachItemEntity entity);
}