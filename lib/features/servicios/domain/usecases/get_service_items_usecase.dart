import 'package:crv_reprosisa/features/servicios/domain/repositories/service_item_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/service_item_entity.dart';

class GetServiceItemsUseCase {
  final ServiceItemsRepository repository;

  GetServiceItemsUseCase(this.repository);

  /// Llama al repositorio para obtener los ítems del servicio solicitado
  Future<Either<Failure, List<ServiceItemEntity>>> call(String serviceId) async {
    return await repository.getServiceItems(serviceId);
  }
}