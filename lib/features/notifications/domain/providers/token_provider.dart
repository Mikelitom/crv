import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class TokenProvider {
  Future<Either<Failure, void>> requestPermission();
  Future<Either<Failure, String>> getToken();
}
