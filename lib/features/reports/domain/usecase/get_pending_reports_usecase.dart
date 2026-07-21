import 'package:crv_reprosisa/features/reports/domain/repository/report_repository.dart';

class GetPendingReportsUsecase {
  final ReportRepository repository;

  GetPendingReportsUsecase(this.repository);

  Future<List<dynamic>> execute() async {
    final reports = await repository.getAllConveyorReports();

    return reports.where((r) {
      final state = r.state.toUpperCase();
      return state == "IN_REVISION";
    }).toList();
  }
}
