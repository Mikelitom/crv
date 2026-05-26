import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/clients.dart';
import 'package:dartz/dartz.dart';

import '../params/create_clients_params.dart';

abstract class ClientRepository {
  Future<Either<Failure, Clients>> createClient(CreateClientParams params);
  Future<Either<Failure, Clients>> updateClient(
    String id,
    CreateClientParams params,
  );
  Future<Either<Failure, List<Clients>>> getAllClients();
  Future<Either<Failure, void>> activateClient(String id);
  
  Future<Either<Failure, void>> deleteClient(String id);
  
  Future<Either<Failure, void>> activateMine(String mineId);
  
  Future<Either<Failure, void>> deleteMine(String mineId);
Future<Either<Failure, void>> createMine(String clientId, CreateMineParams params);}
