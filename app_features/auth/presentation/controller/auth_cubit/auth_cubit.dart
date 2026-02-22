import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

class AuthCubit extends Cubit<AuthState> {
  final GoogleLoginUseCase kGoogleLoginUseCase;

  AuthCubit({
    required this.kGoogleLoginUseCase,
  }) : super(AuthInitialState());

  static AuthCubit get(context) =>
      BlocProvider.of<AuthCubit>(context);
GoogleLoginResponseEntity? googleLoginResponseEntity;
  void googleLoginMithode({
    required String idToken,
  }) async {
    emit(GoogleLoginLoadingState());

    final response = await kGoogleLoginUseCase(
      GoogleLoginParameters(
        idToken: idToken,
      ),
    );

    response.fold(
      (failure) {
        debugPrint('Failure: GoogleLoginErrorState');
        emit(
          GoogleLoginErrorState(
       ),
        );
      },
      (r) {googleLoginResponseEntity=r;
        debugPrint('Success: ${r.message}');
        emit(
          GoogleLoginSucssesState(
            message: r.message!,
          ),
        );
      },
    );
  }
}
