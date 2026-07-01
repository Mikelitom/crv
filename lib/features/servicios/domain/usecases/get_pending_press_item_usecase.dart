import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/press_item_entity.dart';
import '../repositories/press_item_repository.dart';

class GetPendingPressItemsUseCase {
  final PressItemRepository repository;

  GetPendingPressItemsUseCase(this.repository);

  Future<Either<Failure, List<PressItemEntity>>> call(String pressId) async {
    return await repository.getPendingItems(pressId);
  }
}