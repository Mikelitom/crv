import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../entities/component_item.dart';
import '../entities/entities_press.dart';
import '../entities/loan_area.dart'; 
import '../../../../core/error/failure.dart';

abstract class InspeccionRepository {
  Future<Either<Failure, Press>> getPressBySerie(String serie);
  Future<Either<Failure, List<String>>> fetchAllSeries();
  Future<Either<Failure, String>> createPressReport(Map<String, dynamic> reportData);
  Future<Either<Failure, List<ComponentItem>>> getInspectionTemplate();
  Future<Either<Failure, List<LoanArea>>> getLoanAreas();  
  Future<Either<Failure, LoanArea>> createLoanArea(Map<String, String> data);
  Future<Either<Failure, Unit>> createLoan(Map<String, dynamic> data);
  Future<Either<Failure, Uint8List>> getInspectionPdfBinary(String id);
Future<Either<Failure, Map<String, dynamic>>> getLatestLoanStatus(String pressId);}