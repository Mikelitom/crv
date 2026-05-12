import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/banda_template.dart';
import '../entities/client_mine.dart';

abstract class BandaRepository {
  Future<Either<Failure, List<BandaSection>>> getBandaTemplate();
  Future<Either<Failure, List<Client>>> getActiveClients();
  Future<Either<Failure, List<Mine>>> getActiveMines();
  Future<Either<Failure, String>> createBandaReport(Map<String, dynamic> reportData);
}