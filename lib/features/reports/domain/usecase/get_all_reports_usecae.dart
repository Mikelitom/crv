import 'package:crv_reprosisa/features/reports/domain/repository/report_repository.dart';


class GetAllReportsUseCase {
  final ReportRepository repository;

  GetAllReportsUseCase(this.repository);

  // Puedes crear métodos separados o un "Facade" que traiga todo junto
  Future<Map<String, List<dynamic>>> execute() async {
    final vehicles = await repository.getAllVehicleReports();
    final conveyors = await repository.getAllConveyorReports();
    final presses = await repository.getAllPressReports();

    return {
      'vehicles': vehicles,
      'conveyors': conveyors,
      'presses': presses,
    };
  }
}