import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/core/configs/assets/app_vectors.dart';
import 'package:vaxpet/presentation/main_bottom_navigator/pages/main_bottom_navigator.dart';
import '../bloc/splash_cubit.dart';
import '../bloc/splash_state.dart';
import 'introduce.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            AppNavigator.pushReplacement(context, const IntroducePage());
          }
          if (state is Authenticated) {
            AppNavigator.pushReplacement(context, MainBottomNavigatorPage());
          }
        },
        child: Container(
          alignment: Alignment.center,
          child: SvgPicture.asset(AppVectors.logoVaxPet),
        ),
      ),
    );
  }
}
