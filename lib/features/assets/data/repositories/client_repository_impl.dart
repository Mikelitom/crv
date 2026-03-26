import 'dart:io';

import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/data/datasource/client_remote_datasource.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/clients_conveyor.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_clients_params.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/client_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDatasource remote;

  ClientRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, ClientsConveyor>> createClient(
    CreateClientParams params,
  ) async {
    try {
      final client = await remote.createClient(params);
      return Right(client);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ClientsConveyor>>> getAllClients() async {
    try {
      final clients = await remote.getAllClients();
      return Right(clients);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
