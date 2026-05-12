import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/clients.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/client_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllClients {
  final ClientRepository repository;

  GetAllClients(this.repository);

  Future<Either<Failure, List<Clients>>> call() {
    return repository.getAllClients();
  }
}
