// lib/features/assets/domain/usecases/get_all_presses_usecase.dart
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/press_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllPressesUseCase {
  final PressRepository repository;

  GetAllPressesUseCase(this.repository);

  Future<Either<Failure, List<Press>>> call() async {
    return await repository.getAllPress();
  }
}