import 'dart:io';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/data/datasource/client_remote_datasource.dart';
import 'package:crv_reprosisa/features/assets/data/models/create_client_request.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/clients.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_clients_params.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/client_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../data/models/create_mine_request.dart';
class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDatasource remote;

  ClientRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, Clients>> createClient(
    CreateClientParams params,
  ) async {
    try {
      final request = CreateClientRequest.fromParams(params);
      final client = await remote.createClient(request);
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
  Future<Either<Failure, Clients>> updateClient(
    String id,
    CreateClientParams params,
  ) async {
    try {
      final request = CreateClientRequest.fromParams(params);
      final client = await remote.updateClient(id, request);
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
  Future<Either<Failure, List<Clients>>> getAllClients() async {
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
  @override
  Future<Either<Failure, void>> activateClient(String id) async {
    try {
      await remote.activateClient(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteClient(String id) async {
    try {
      await remote.deleteClient(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> activateMine(String mineId) async {
    try {
      await remote.activateMine(mineId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMine(String mineId) async {
    try {
      await remote.deleteMine(mineId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
 @override
  Future<Either<Failure, void>> createMine(String clientId, CreateMineParams params) async {
    try {
      final request = CreateMineRequest.fromParams(params, clientId: clientId);
      await remote.createMine(clientId, request);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
