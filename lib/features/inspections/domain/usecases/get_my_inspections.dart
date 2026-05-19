import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../presentation/models/inspector_row_ui.dart';
import '../repositories/inspection_repository.dart';

class GetMyInspectionsUseCase {
  final InspectionRepository repository;
  GetMyInspectionsUseCase(this.repository);

  Future<Either<Failure, List<InspectionRowUI>>> call() async {
    return await repository.getMyInspections();
  }
}