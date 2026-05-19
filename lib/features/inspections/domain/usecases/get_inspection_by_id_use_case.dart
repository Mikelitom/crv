
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart'; 
import '../entities/inspection.dart'; 
import '../repositories/inspection_repository.dart';

class GetInspectionByIdUseCase {
  final InspectionRepository repository;

  GetInspectionByIdUseCase(this.repository);

  Future<Either<Failure, Inspection>> call(String id) async {
    return await repository.getInspectionById(id);
  }
}