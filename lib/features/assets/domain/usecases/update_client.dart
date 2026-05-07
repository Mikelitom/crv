import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/clients.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_clients_params.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/client_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateClient {
  final ClientRepository repository;

  UpdateClient(this.repository);

  Future<Either<Failure, Clients>> call(String id, CreateClientParams params) {
    return repository.updateClient(id, params);
  }
}
