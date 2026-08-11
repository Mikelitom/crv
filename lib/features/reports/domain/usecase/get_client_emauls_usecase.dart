import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/reports/domain/repository/report_repository.dart';

class GetClientEmailsUseCase {
  final ReportRepository repository;

  GetClientEmailsUseCase(this.repository);

  Future<Either<Failure, List<String>>> call(String clientId) async {
    return await repository.getClientEmails(clientId);
  }
}