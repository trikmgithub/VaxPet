import 'package:flutter/material.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/common/widgets/reactive_button/reactive_button.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:dartz/dartz.dart';

import '../../../common/helper/message/display_message.dart';
import '../../../domain/auth/usecases/logout.dart';
import '../../../service_locator.dart';
import '../../splash/pages/introduce.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: AppColors.textBlack,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Nội dung trang Tài khoản',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            const SizedBox(height: 32),
            _buttonLogout(context),
          ],
        ),
      ),
    );
  }

  Widget _buttonLogout(BuildContext context) {
    return ReactiveButton(
      title: 'Đăng xuất',
      activeColor: AppColors.primary,
      onPressed: () async {
        try {
          await sl<LogoutUseCase>().call(params: null);
          // Trả về Either.Right khi thành công
          return Right('success');
        } catch (e) {
          // Trả về Either.Left khi thất bại
          return Left(e.toString());
        }
      },
      onSuccess: () {
        AppNavigator.pushAndRemove(context, IntroducePage());
      },
      onFailure: (error) {
        DisplayMessage.errorMessage(error.toString(), context);
      },
    );
  }
}
