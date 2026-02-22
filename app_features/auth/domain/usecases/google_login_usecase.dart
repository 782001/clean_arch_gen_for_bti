import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/base_usecase/base_usecase.dart';

class GoogleLoginUseCase
    extends BaseUseCase<GoogleLoginResponseEntity, GoogleLoginParameters> {
  final GoogleLoginBaseRepository baseRepository;

  GoogleLoginUseCase({required this.baseRepository});

  @override
  Future<Either<dynamic, GoogleLoginResponseEntity>> call(
      GoogleLoginParameters parameters) async {
    return await baseRepository.call(parameters: parameters);
  }
}

class GoogleLoginParameters extends Equatable {
  final String idToken;

  const GoogleLoginParameters({
    required this.idToken,
  });

  @override
  List<Object?> get props => [idToken];
}
