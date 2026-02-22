import 'package:dartz/dartz.dart';
import 'package:dartz/dartz.dart';

abstract class GoogleLoginBaseRepository {
  Future<Either<dynamic, GoogleLoginResponseEntity>> call({
    required GoogleLoginParameters parameters,
  });
}

