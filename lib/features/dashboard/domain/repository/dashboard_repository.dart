import 'package:crv_reprosisa/features/dashboard/data/model/report_counters_model.dart';
import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';

abstract class DashboardCountersRepository {
  Future<Either<Failure, ReportCountersModel>> getReportCounters();
}