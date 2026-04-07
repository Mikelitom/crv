import 'package:dartz/dartz.dart';
import '../entities/component_item.dart';
import '../entities/entities_press.dart';
import '../../../../core/error/failure.dart';

abstract class InspeccionRepository {
Future<Either<Failure, Press>> getPressBySerie(String serie);
  Future<Either<Failure, List<String>>> fetchAllSeries();
  
  Future<Either<Failure, Unit>> createPressReport(Map<String, dynamic> reportData);
  Future<Either<Failure, List<ComponentItem>>> getInspectionTemplate();
}