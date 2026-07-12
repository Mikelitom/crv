import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/banda_repository.dart';

class UpdateBandaReportUseCase {
  final BandaRepository repository;
  UpdateBandaReportUseCase(this.repository);

  Future<Either<Failure, String>> call(String reportId, Map<String, dynamic> data) async {
    return await repository.updateBandaReport(reportId, data);
  }
}