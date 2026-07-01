import 'package:crv_reprosisa/features/servicios/domain/entities/attach_item_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

abstract class AttachItemsRepository {
  Future<Either<Failure, void>> attachItems(AttachItemsEntity entity);
}