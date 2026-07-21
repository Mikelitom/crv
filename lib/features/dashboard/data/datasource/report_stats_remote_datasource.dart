import 'package:crv_reprosisa/features/dashboard/data/model/report_stats_model.dart';
import 'package:dio/dio.dart';

abstract class ReportStatsRemoteDatasource {
  Future<List<ReportStatModel>> getReportStats();
}

class ReportStatsRemoteDatasourceImpl implements ReportStatsRemoteDatasource {
  final Dio dio;

  ReportStatsRemoteDatasourceImpl(this.dio);

  @override
  Future<List<ReportStatModel>> getReportStats() async {
    final response = await dio.get('/asset/reports-stats');
    return ReportStatModel.listFromJson(response.data);
  }
}