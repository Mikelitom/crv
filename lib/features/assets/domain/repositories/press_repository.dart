// lib/features/assets/domain/repositories/press_repository.dart
import '../entities/press_report_detail_entity.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/press_history.dart';
import 'package:crv_reprosisa/features/assets/domain/params/create_press_params.dart';
import 'package:dartz/dartz.dart';

abstract class PressRepository {
  Future<Either<Failure, Press>> createPress(CreatePressParams params);
  Future<Either<Failure, Press>> updatePress(
    String id,
    CreatePressParams params,
  );
  Future<Either<Failure, List<Press>>> getAllPress();
  Future<Either<Failure, Unit>> activatePress(String id);
  Future<Either<Failure, Unit>> deactivatePress(String id);
  Future<Either<Failure, PressReportDetailEntity>> getPressReportDetail(String versionId);
  Future<Either<Failure, List<PressHistory>>> getPressHistory(String pressId);
}