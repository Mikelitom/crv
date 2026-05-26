import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/client_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteMine {
  final ClientRepository repository;
  DeleteMine(this.repository);

  Future<Either<Failure, void>> call(String mineId) => repository.deleteMine(mineId);
}