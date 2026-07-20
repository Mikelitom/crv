import 'package:crv_reprosisa/features/dashboard/data/model/report_counters_model.dart';
import 'package:crv_reprosisa/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';

class GetReportCountersUseCase {
  final DashboardCountersRepository repository;

  GetReportCountersUseCase(this.repository);

  Future<Either<Failure, ReportCountersModel>> call() async {
    return await repository.getReportCounters();
  }
}