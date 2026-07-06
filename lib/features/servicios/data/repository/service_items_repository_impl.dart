import 'package:crv_reprosisa/features/servicios/data/datasource/v_service_datasource.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/service_item_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/service_item_entity.dart';


class ServiceItemsRepositoryImpl implements ServiceItemsRepository {
  final ServiceDataSource remoteDataSource;

  ServiceItemsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ServiceItemEntity>>> getServiceItems(String serviceId) async {
    try {
      final remoteItems = await remoteDataSource.getServiceItems(serviceId);
      return Right(remoteItems);
    } catch (e) {
      // Aquí puedes mapear el error a un tipo de Failure específico
      return Left(ServerFailure(e.toString()));
    }
  }
}