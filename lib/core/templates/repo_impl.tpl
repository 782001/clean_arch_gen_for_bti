import 'package:dartz/dartz.dart';

import '../../domain/entities/{{feature}}_entity.dart';
import '../../domain/repositories/{{feature}}_repo_base.dart';
import '../../domain/usecases/{{feature}}_usecase.dart';
import '../data_sources/{{feature}}_remote_ds.dart';

class {{Feature}}Repository extends {{Feature}}BaseRepository {
  final {{Feature}}BaseRemoteDataSource baseRemoteDataSource;

  {{Feature}}Repository(this.baseRemoteDataSource);

  @override
  Future<Either<dynamic, {{entity}}>> call({
    required {{Feature}}Parameters parameters,
  }) async {
    try {
      final response = await baseRemoteDataSource.{{Feature}}(
        parameters: parameters,
      );
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }
}

