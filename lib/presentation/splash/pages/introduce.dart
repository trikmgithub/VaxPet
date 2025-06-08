import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vaxpet/presentation/splash/pages/register_signin.dart';

import '../../../common/helper/navigation/app_navigation.dart';
import '../../../core/configs/assets/app_vectors.dart';
import '../../../core/configs/theme/app_colors.dart';

class IntroducePage extends StatelessWidget {
  const IntroducePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.only(top: 100, right: 16, left: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _logoVaxPet(),
            const SizedBox(height: 150),
            _title(),
            const SizedBox(height: 16),
            _description(),
            const SizedBox(height: 32),
            _buttonGetStarted(context),
          ],
        ),
      ),
    );
  }

  Widget _logoVaxPet() {
    return Container(
      alignment: Alignment.center,
      child: SvgPicture.asset(AppVectors.logoVaxPet),
    );
  }

  Widget _title() {
    return const Text(
      'Hệ thống tiêm chủng VaxPet',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textGray,
      ),
    );
  }

  Widget _description() {
    return const Text(
      'Theo dõi lịch tiêm chủng và chăm sóc sức khỏe cho thú cưng dễ dàng hơn bao giờ hết.',
      style: TextStyle(fontSize: 16, color: AppColors.textGray),
      textAlign: TextAlign.center,
    );
  }

  Widget _buttonGetStarted(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        AppNavigator.push(context, const RegisterSigninPage());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 30),
        textStyle: const TextStyle(fontSize: 24),
      ),
      child: const Text(
        'Bắt đầu',
        style: TextStyle(color: AppColors.textWhite),
      ),
    );
  }
}
