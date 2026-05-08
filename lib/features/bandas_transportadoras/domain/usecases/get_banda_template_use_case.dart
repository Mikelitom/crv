import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/banda_template.dart';
import '../repositories/banda_repository.dart';


class GetBandaTemplateUseCase {
  final BandaRepository repository;
  GetBandaTemplateUseCase(this.repository);

  Future<Either<Failure, List<BandaSection>>> call() async {
    return await repository.getBandaTemplate();
  }
}