// lib/features/assets/domain/usecases/get_conveyor_report_detail_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/conveyor_report_detail.dart';
import '../repositories/client_repository.dart';

class GetConveyorReportDetailUseCase {
  final ClientRepository repository;

  GetConveyorReportDetailUseCase(this.repository);

  Future<Either<Failure, ConveyorReportDetail>> call(String versionId) async {
    return await repository.getReportDetail(versionId);
  }
}