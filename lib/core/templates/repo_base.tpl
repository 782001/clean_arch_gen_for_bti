import 'package:dartz/dartz.dart';

import '../entities/{{feature}}_entity.dart';
import '../usecases/{{feature}}_usecase.dart';

abstract class {{Feature}}BaseRepository {
  Future<Either<dynamic, {{entity}}>> call({
    required {{Feature}}Parameters parameters,
  });
}

