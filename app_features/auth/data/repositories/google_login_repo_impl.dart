import 'package:dartz/dartz.dart';

class GoogleLoginRepository extends GoogleLoginBaseRepository {
  final GoogleLoginBaseRemoteDataSource baseRemoteDataSource;

  GoogleLoginRepository(this.baseRemoteDataSource);

  @override
  Future<Either<dynamic, GoogleLoginResponseEntity>> call({
    required GoogleLoginParameters parameters,
  }) async {
    try {
      final response = await baseRemoteDataSource.GoogleLogin(
        parameters: parameters,
      );
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }
}

