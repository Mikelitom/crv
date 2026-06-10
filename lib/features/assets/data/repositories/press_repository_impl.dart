// lib/features/assets/data/repositories/press_repository_impl.dart
import 'dart:io';

import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/data/datasource/press_remote_datasource.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/press_history.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/press_report_detail_entity.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_press_params.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/press_repository.dart';
import 'package:crv_reprosisa/features/prensas_industriales/data/datasource/press_inspection_local_datasource.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class PressRepositoryImpl implements PressRepository {
  final PressRemoteDatasource remote;
  final PressInspectionLocalDataSource local;

  PressRepositoryImpl(this.remote, this.local);

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
      await local.clearPresses();
      await local.savePresses(press);
      return Right(press);
    } on DioException catch (e) {
      final press = await local.getPresses();
      if (press.isNotEmpty) return Right(press);
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> activatePress(String id) async {
    try {
      await remote.activatePress(id);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deactivatePress(String id) async {
    try {
      await remote.deactivatePress(id);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PressHistory>>> getPressHistory(
    String pressId,
  ) async {
    try {
      // 1. Llamamos al datasource
      final history = await remote.getPressHistory(pressId);
      // 2. Envolvemos el éxito en Right
      return Right(history);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PressReportDetailEntity>> getPressReportDetail(
    String versionId,
  ) async {
    try {
      final detail = await remote.getPressReportDetail(versionId);
      return Right(detail);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
