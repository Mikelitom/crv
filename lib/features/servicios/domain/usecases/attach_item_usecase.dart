import 'package:crv_reprosisa/features/servicios/domain/entities/attach_item_entity.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/attach_item_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';


class AttachItemsUseCase {
  final AttachItemsRepository repository;
  AttachItemsUseCase(this.repository);

  Future<Either<Failure, void>> call(AttachItemsEntity entity) {
    return repository.attachItems(entity);
  }
}