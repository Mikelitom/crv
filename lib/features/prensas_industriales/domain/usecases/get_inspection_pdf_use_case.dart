import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/inspeccion_repository.dart';

class GetInspectionPdfUseCase {
  final InspeccionRepository repository;

  GetInspectionPdfUseCase(this.repository);

  Future<Either<Failure, Uint8List>> call(String reportId) async {
    return await repository.getInspectionPdfBinary(reportId);
  }
}