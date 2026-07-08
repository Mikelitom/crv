// lib/features/assets/domain/repositories/press_repository.dart
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/press.dart';
import 'package:dartz/dartz.dart';

abstract class PressRepository {
  Future<Either<Failure, List<Press>>> getAllPress();
}