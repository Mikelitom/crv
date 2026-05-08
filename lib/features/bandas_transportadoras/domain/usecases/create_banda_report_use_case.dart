import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/banda_repository.dart';

class CreateBandaReportUseCase {
  final BandaRepository repository;
  CreateBandaReportUseCase(this.repository);

  Future<Either<Failure, String>> call(Map<String, dynamic> reportData) async {
    return await repository.createBandaReport(reportData);
  }
}