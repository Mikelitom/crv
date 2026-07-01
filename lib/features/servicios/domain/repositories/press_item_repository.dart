// lib/features/assets/domain/repositories/press_item_repository_g.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/press_item_entity.dart';

abstract class PressItemRepository {
  Future<Either<Failure, List<PressItemEntity>>> getPendingItems(String pressId);
}