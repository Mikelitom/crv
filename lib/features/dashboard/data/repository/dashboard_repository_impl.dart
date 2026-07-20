import 'dart:io';
import 'package:crv_reprosisa/features/dashboard/data/model/report_counters_model.dart';
import 'package:crv_reprosisa/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import '../datasource/dashboard_remote_datasource.dart';

class DashboardCountersRepositoryImpl implements DashboardCountersRepository {
  final DashboardRemoteDatasource remote;

  DashboardCountersRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, ReportCountersModel>> getReportCounters() async {
    try {
      final counters = await remote.getReportCounters();
      return Right(counters);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}