import 'package:crv_reprosisa/features/servicios/data/datasource/press_service_datasource.dart'; // Asegúrate de importar el datasource correcto
import 'package:crv_reprosisa/features/servicios/data/models/press/press_attach_item_model.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/press_attach_item_entity.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/press_attach_item_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

class PressAttachItemRepositoryImpl implements PressAttachItemRepository {
  // CORRECCIÓN: Cambiamos ServiceDataSource por PressServiceDataSource
  final PressServiceDataSource remoteDataSource; 
  
  PressAttachItemRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> attachItems(PressAttachItemEntity entity) async {
    try {
      final model = PressAttachItemModel.fromEntity(entity);
      await remoteDataSource.attachPressItems(entity.serviceId, model);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}