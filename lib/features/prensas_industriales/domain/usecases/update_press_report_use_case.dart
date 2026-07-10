import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/inspeccion_repository.dart';

class UpdatePressReportUseCase {
  final InspeccionRepository repository;
  UpdatePressReportUseCase(this.repository);

  Future<Either<Failure, String>> call(String reportId, Map<String, dynamic> data) async {
    return await repository.updatePressReport(reportId, data);
  }
}