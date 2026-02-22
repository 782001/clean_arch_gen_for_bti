abstract class AuthState {}

class AuthInitialState extends AuthState {}

class GoogleLoginLoadingState extends AuthState {}

class GoogleLoginErrorState extends AuthState {


  GoogleLoginErrorState();
}

class GoogleLoginSucssesState extends AuthState {
  final String message;

  GoogleLoginSucssesState({
    required this.message,
  });
}
