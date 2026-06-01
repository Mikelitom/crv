import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/client_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteClient {
  final ClientRepository repository;
  DeleteClient(this.repository);

  Future<Either<Failure, void>> call(String id) => repository.deleteClient(id);
}