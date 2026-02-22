import 'package:dartz/dartz.dart';
import 'package:dartz/dartz.dart';

abstract class {{Feature}}BaseRepository {
  Future<Either<dynamic, {{entity}}>> call({
    required {{Feature}}Parameters parameters,
  });
}

