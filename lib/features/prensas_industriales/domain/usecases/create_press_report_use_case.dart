import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/inspeccion_repository.dart';

class CreatePressReportUseCase {
  final InspeccionRepository repository;

  CreatePressReportUseCase(this.repository);

  Future<Either<Failure, String>> call(Map<String, dynamic> reportData) async {
    return await repository.createPressReport(reportData);
  }
}