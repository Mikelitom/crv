 import 'dart:io';

import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/data/datasource/vehicle_remote_datasource.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/vehicle.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_vehicle_params.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/vehicle_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDatasource remote;

  VehicleRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, Vehicle>> createVehicle(
    CreateVehicleParams params,
  ) async {
    try {
      final vehicle = await remote.createVehicle(params);
      return Right(vehicle);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Vehicle>> updateVehicle(
    String id,
    CreateVehicleParams params,
  ) async {
    try {
      final vehicle = await remote.updateVehicle(id, params);
      return Right(vehicle);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Vehicle>>> getAllVehicle() async {
    try {
      final vehicle = await remote.getAllVehicle();
      return Right(vehicle);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
