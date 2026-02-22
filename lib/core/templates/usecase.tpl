import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/base_usecase/base_usecase.dart';

class {{Feature}}UseCase
    extends BaseUseCase<{{entity}}, {{Feature}}Parameters> {
  final {{Feature}}BaseRepository baseRepository;

  {{Feature}}UseCase({required this.baseRepository});

  @override
  Future<Either<dynamic, {{entity}}>> call(
      {{Feature}}Parameters parameters) async {
    return await baseRepository.call(parameters: parameters);
  }
}

class {{Feature}}Parameters extends Equatable {
  {{parameters}}

  const {{Feature}}Parameters({
    {{constructor}}
  });

  @override
  List<Object?> get props => [{{props}}];
}
