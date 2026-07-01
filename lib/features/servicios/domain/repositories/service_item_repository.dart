import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/service_item_entity.dart';

abstract class ServiceItemsRepository {
  Future<Either<Failure, List<ServiceItemEntity>>> getServiceItems(String serviceId);
}