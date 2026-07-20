import 'package:crv_reprosisa/features/dashboard/data/model/report_counters_model.dart';
import 'package:dio/dio.dart';

abstract class DashboardRemoteDatasource {
  Future<ReportCountersModel> getReportCounters();
}

class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  final Dio dio;

  DashboardRemoteDatasourceImpl(this.dio);

  @override
  Future<ReportCountersModel> getReportCounters() async {
    final response = await dio.get('/asset/report-counters');
    return ReportCountersModel.fromJson(response.data);
  }
}