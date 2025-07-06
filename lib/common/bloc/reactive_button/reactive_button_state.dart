abstract class ReactiveButtonState {}

class ReactiveButtonInitialState extends ReactiveButtonState {}

class ReactiveButtonLoadingState extends ReactiveButtonState {}

class ReactiveButtonSuccessState extends ReactiveButtonState {}

class ReactiveButtonFailureState extends ReactiveButtonState {
  final String errorMessage;

  ReactiveButtonFailureState({required this.errorMessage});
}
