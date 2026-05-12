import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/clients.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_clients_params.dart';
import 'package:dartz/dartz.dart';

import '../repositories/client_repository.dart';

class CreateClient {
  final ClientRepository repository;

  CreateClient(this.repository);

  Future<Either<Failure, Clients>> call(CreateClientParams params) {
    return repository.createClient(params);
  }
}
