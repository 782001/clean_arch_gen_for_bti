import 'package:dartz/dartz.dart';

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

