import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/client_mine.dart';
import '../repositories/banda_repository.dart';

class GetActiveClientsUseCase {
  final BandaRepository repository;
  GetActiveClientsUseCase(this.repository);

  Future<Either<Failure, List<Client>>> call() async {
    return await repository.getActiveClients();
  }
}