import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/client_repository.dart';
import 'package:dartz/dartz.dart';

class ActivateClient {
  final ClientRepository repository;
  ActivateClient(this.repository);

  Future<Either<Failure, void>> call(String id) => repository.activateClient(id);
}