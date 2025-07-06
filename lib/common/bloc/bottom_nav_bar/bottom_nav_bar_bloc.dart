import 'package:flutter_bloc/flutter_bloc.dart';

import 'bottom_nav_bar_event.dart';
import 'bottom_nav_bar_state.dart';

class BottomNavBarBloc extends Bloc<BottomNavBarEvent, BottomNavBarState> {
  BottomNavBarBloc() : super(NavigationChanged(index: 0)) {
    on<NavigateTo>((event, emit) {
      emit(NavigationChanged(index: event.index));
    });
  }
}
