import 'dart:io';

import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/data/datasource/press_remote_datasource.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_press_params.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/press_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class PressRepositoryImpl implements PressRepository {
  final PressRemoteDatasource remote;

  PressRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, Press>> createPress(CreatePressParams params) async {
    try {
      final press = await remote.createPress(params);
      return Right(press);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Press>> updatePress(
    String id,
    CreatePressParams params,
  ) async {
    try {
      final press = await remote.updatePress(id, params);
      return Right(press);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Press>>> getAllPress() async {
    try {
      final press = await remote.getAllPress();
      return Right(press);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
