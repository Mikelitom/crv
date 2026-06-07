import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/client_history.dart';
import '../../domain/repositories/client_repository.dart';

class GetClientHistory {
  final ClientRepository repository;

  GetClientHistory(this.repository);

  Future<Either<Failure, List<ClientHistory>>> call(String clientId) async {
    return await repository.getClientHistory(clientId);
  }
}