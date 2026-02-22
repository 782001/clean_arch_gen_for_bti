abstract class {{Module}}State {}

class {{Module}}InitialState extends {{Module}}State {}

class {{Feature}}LoadingState extends {{Module}}State {}

class {{Feature}}ErrorState extends {{Module}}State {


  {{Feature}}ErrorState();
}

class {{Feature}}SucssesState extends {{Module}}State {
  final String message;

  {{Feature}}SucssesState({
    required this.message,
  });
}
