import 'package:crv_reprosisa/features/servicios/data/datasource/v_service_datasource.dart';
import 'package:crv_reprosisa/features/servicios/data/models/vehiculos/attach_item_model.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/attach_item_entity.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/attach_item_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';


class AttachItemsRepositoryImpl implements AttachItemsRepository {
  final ServiceDataSource remoteDataSource;
  AttachItemsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> attachItems(AttachItemsEntity entity) async {
    try {
      final model = AttachItemsModel(serviceId: entity.serviceId, itemIds: entity.itemIds);
      await remoteDataSource.attachItems(entity.serviceId, model);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}