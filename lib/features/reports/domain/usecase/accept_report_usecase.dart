import 'package:crv_reprosisa/features/reports/domain/repository/report_repository.dart';

class AcceptConveyorReportUseCase {
  final ReportRepository repository;

  AcceptConveyorReportUseCase(this.repository);

  // El caso de uso siempre expone un solo método público que ejecuta la lógica
  Future<void> call(String reportId) async {
    // Aquí puedes agregar lógica de validación adicional si fuera necesaria
    // antes de ir al repositorio
    return await repository.acceptReport(reportId);
  }
}