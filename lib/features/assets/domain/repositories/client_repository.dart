import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/clients_conveyor.dart';
import 'package:dartz/dartz.dart';

import '../params/create_clients_params.dart';

abstract class ClientRepository {
  Future<Either<Failure, ClientsConveyor>> createClient(
    CreateClientParams params,
  );
  Future<Either<Failure, List<ClientsConveyor>>> getAllClients();
}
