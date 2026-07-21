import 'dart:io';
import 'package:crv_reprosisa/features/dashboard/data/datasource/report_stats_remote_datasource.dart';
import 'package:crv_reprosisa/features/dashboard/data/model/report_stats_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:crv_reprosisa/core/error/failure.dart';


abstract class ReportStatsRepository {
  Future<Either<Failure, List<ReportStatModel>>> getReportStats();
}

class ReportStatsRepositoryImpl implements ReportStatsRepository {
  final ReportStatsRemoteDatasource remote;

  ReportStatsRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<ReportStatModel>>> getReportStats() async {
    try {
      final stats = await remote.getReportStats();
      return Right(stats);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}