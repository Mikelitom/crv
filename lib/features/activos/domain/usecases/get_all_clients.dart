import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/activos/domain/entities/clients_conveyor.dart';
import 'package:crv_reprosisa/features/activos/domain/repositories/client_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllClients {
  final ClientRepository repository;

  GetAllClients(this.repository);

  Future<Either<Failure, List<ClientsConveyor>>> call() {
    return repository.getAllClients();
  }
}
