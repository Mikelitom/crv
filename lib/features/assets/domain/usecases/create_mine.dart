import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_clients_params.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/client_repository.dart';

/// Caso de uso para crear una nueva mina asociada a un cliente existente.
/// Requiere el ID del cliente para vincular la nueva mina.
class CreateMine {
  final ClientRepository repository;

  CreateMine(this.repository);

  Future<Either<Failure, void>> call(String clientId, CreateMineParams params) {
    return repository.createMine(clientId, params);
  }
}