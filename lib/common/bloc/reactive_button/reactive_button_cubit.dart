import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/common/bloc/reactive_button/reactive_button_state.dart';

class ReactiveButtonCubit extends Cubit<ReactiveButtonState> {
  ReactiveButtonCubit() : super(ReactiveButtonInitialState());

  Future<void> execute(Function asyncFunction) async {
    emit(ReactiveButtonLoadingState());
    try {
      Either result = await asyncFunction();
      result.fold(
        (error) {
          emit(ReactiveButtonFailureState(errorMessage: error));
        },
        (data) {
          emit(ReactiveButtonSuccessState());
        },
      );
    } catch (e) {
      emit(ReactiveButtonFailureState(errorMessage: e.toString()));
    }
  }
}
