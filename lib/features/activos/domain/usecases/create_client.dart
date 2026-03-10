import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/activos/domain/entities/clients_conveyor.dart';
import 'package:crv_reprosisa/features/activos/domain/params/create_clients_params.dart';
import 'package:dartz/dartz.dart';

import '../repositories/client_repository.dart';

class CreateClient {
  final ClientRepository repository;

  CreateClient(this.repository);

  Future<Either<Failure, ClientsConveyor>> call(CreateClientParams params) {
    return repository.createClient(params);
  }
}
