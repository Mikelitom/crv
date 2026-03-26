import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/vehicle_type.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/vehicle_type_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllTypes {
  final VehicleTypeRepository repository;

  GetAllTypes(this.repository);

  Future<Either<Failure, List<VehicleType>>> call() {
    return repository.getAllTypes();
  }
}
