import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/core/configs/assets/app_images.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../core/configs/assets/app_vectors.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../auth/pages/register.dart';
import '../../auth/pages/signin.dart';

class RegisterSigninPage extends StatelessWidget {
  const RegisterSigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: false,
      ),
      resizeToAvoidBottomInset: false, // Thêm dòng này để ngăn màn hình resize khi bàn phím xuất hiện
      body: Stack(
        fit: StackFit.expand, // Đảm bảo Stack mở rộng hết không gian
        children: [
          // Main content
          SafeArea(
            minimum: EdgeInsets.only(right: 16, left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _logoVaxPet(),
                const SizedBox(height: 50),
                _title(),
                const SizedBox(height: 16),
                _description(),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buttonRegister(context),
                    _buttonSignin(context),
                  ],
                ),
              ],
            ),
          ),
          // Cat and Dog image fixed at bottom
          Positioned(
            left: 0,
            bottom: 0,
            child: _imageCatDog(),
          ),
        ],
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
        color: Colors.grey,
      ),
    );
  }

  Widget _description() {
    return const Text(
      'Bảo vệ người bạn nhỏ của bạn mỗi ngày',
      style: TextStyle(fontSize: 16, color: Colors.grey),
      textAlign: TextAlign.center,
    );
  }

  Widget _buttonRegister(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        AppNavigator.push(context, RegisterPage());
      },
      child: const Text(
          'Đăng ký',
        style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 16,
            fontWeight: FontWeight.bold
        )
      ),
    );
  }

  Widget _buttonSignin(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        AppNavigator.push(context, SigninPage());
      },
      child: const Text(
          'Đăng nhập',
        style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 16,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _imageCatDog() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.zero,
        alignment: Alignment.bottomLeft,
        child: Image(
          image: AssetImage(AppImages.catAndDog),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
