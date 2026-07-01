// lib/features/assets/data/repositories/press_item_repository_impl.dart
import 'package:crv_reprosisa/features/servicios/domain/repositories/press_item_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/press_item_entity.dart';
import '../datasource/press_service_datasource.dart';

class PressItemRepositoryImpl implements PressItemRepository {
  final PressServiceDataSource remoteDataSource;

  PressItemRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PressItemEntity>>> getPendingItems(String pressId) async {
    try {
      final items = await remoteDataSource.getPendingItems(pressId);
      return Right(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}