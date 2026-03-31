import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import '../datasource/catalogo_remote_datasource.dart';
import '../../domain/repositories/catalogo_repositories.dart';
import '../models/vehicle_state_model.dart'; 
import '../models/press_loan_model.dart';

class CatalogoRepositoryImpl implements CatalogoRepository {
  final CatalogoRemoteDataSource remote;

  CatalogoRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<VehicleStateModel>>> getVehicles() async {
    try {
      final res = await remote.getVehicles();
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PressLoanModel>>> getPresses() async {
    try {
      final res = await remote.getPresses();
      return Right(res);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateVehicleStatus({required String id, required bool isActive}) async {
    try {
      await remote.updateVehicleStatus(id, isActive);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePressStatus({required String id, required bool isActive}) async {
    try {
      await remote.updatePressStatus(id, isActive);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteVehicle(String id) async {
    try {
      await remote.deleteVehicle(id);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePress(String id) async {
    try {
      await remote.deletePress(id);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}