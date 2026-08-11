import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/reports/domain/repository/report_repository.dart';

class SendReportEmailUseCase {
  final ReportRepository repository;

  SendReportEmailUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String versionId,
    required String email,
    required String message,
    required Uint8List pdfBytes,
  }) async {
    return await repository.sendReportEmail(
      versionId: versionId,
      email: email,
      message: message,
      pdfBytes: pdfBytes,
    );
  }
}