import 'package:crv_reprosisa/features/inspections/domain/entities/inspection.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../presentation/models/inspector_row_ui.dart';


abstract class InspectionRepository {
  Future<Either<Failure, List<InspectionRowUI>>> getMyInspections();
  Future<Either<Failure, Inspection>> getInspectionById(String id);
}