import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/press_report_detail_entity.dart';
import '../repositories/press_repository.dart';

class GetPressReportDetailUseCase {
  final PressRepository repository;

  GetPressReportDetailUseCase(this.repository);

  Future<Either<Failure, PressReportDetailEntity>> call(String versionId) async {
    return await repository.getPressReportDetail(versionId);
  }
}