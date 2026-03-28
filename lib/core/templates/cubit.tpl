import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/{{feature}}_entity.dart';
import '../../../domain/usecases/{{feature}}_usecase.dart';
import '{{module}}_states.dart';

class {{Module}}Cubit extends Cubit<{{Module}}State> {
  final {{Feature}}UseCase k{{Feature}}UseCase;

  {{Module}}Cubit({
    required this.k{{Feature}}UseCase,
  }) : super({{Module}}InitialState());

  static {{Module}}Cubit get(context) =>
      BlocProvider.of<{{Module}}Cubit>(context);
{{entity}}? {{entityCamel}};
  void {{featureCamel}}Method({{cubitParameters}}) async {
    emit({{Feature}}LoadingState());

    final response = await k{{Feature}}UseCase(
      {{Feature}}Parameters(
        {{usecaseParams}}
      ),
    );

    response.fold(
      (failure) {
        debugPrint('Failure: {{Feature}}ErrorState');
        emit(
          {{Feature}}ErrorState(
       ),
        );
      },
      (r) {{{entityCamel}}=r;
        debugPrint('Success: ${r.message}');
        emit(
          {{Feature}}SucssesState(
            message: r.message!,
          ),
        );
      },
    );
  }
}
