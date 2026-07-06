import 'package:crv_reprosisa/features/servicios/domain/entities/press_attach_item_entity.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/press_attach_item_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

class AttachPressItemUseCase {
  final PressAttachItemRepository repository;
  AttachPressItemUseCase(this.repository);

  Future<Either<Failure, void>> call(PressAttachItemEntity entity) {
    return repository.attachItems(entity);
  }
}