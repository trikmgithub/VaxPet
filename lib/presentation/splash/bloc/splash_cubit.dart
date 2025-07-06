import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaxpet/presentation/splash/bloc/splash_state.dart';

import '../../../domain/auth/usecases/is_logged_in.dart';
import '../../../service_locator.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(DisplaySplash());

  Future<void> appStarted() async {
    await Future.delayed(const Duration(seconds: 2));
    var isLoggedIn = await sl<IsLoggedInUseCase>().call();
    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(UnAuthenticated());
    }
  }
}
