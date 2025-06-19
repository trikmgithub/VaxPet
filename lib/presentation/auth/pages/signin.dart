import 'package:flutter/material.dart';
import 'package:vaxpet/data/auth/models/signin_req_params.dart';
import 'package:vaxpet/presentation/auth/pages/verify_otp.dart';

import '../../../common/helper/message/display_message.dart';
import '../../../common/helper/navigation/app_navigation.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../common/widgets/reactive_button/reactive_button.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/auth/usecases/signin.dart';
import '../../../service_locator.dart';

class SigninPage extends StatelessWidget {
  SigninPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ValueNotifier<bool> _isPasswordHidden = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BasicAppbar(
          hideBack: false,
        ),
        body: SafeArea(
          minimum: EdgeInsets.only(
            top: 100,
            right: 16,
            left: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _title(),
              const SizedBox(height: 30),
              _emailField(),
              const SizedBox(height: 20),
              _passwordField(),
              const SizedBox(height: 20),
              _buttonSignin(context),
            ],
          ),
        )
    );
  }

  Widget _title() {
    return Container(
      alignment: Alignment.center,
      child: const Text(
        'Đăng nhập',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: AppColors.textBlack,
        ),
      ),
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        hintText: 'Nhập email của bạn',
      ),
    );
  }

  Widget _passwordField() {
    return ValueListenableBuilder<bool>(
        valueListenable: _isPasswordHidden,
        builder: (context, isHidden, _) {
          return TextField(
            controller: _passwordController,
            obscureText: isHidden,
            decoration: InputDecoration(
              hintText: 'Nhập mật khẩu của bạn',
              suffixIcon: IconButton(
                icon: Icon(
                  isHidden ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.textGray,
                ),
                onPressed: () {
                  _isPasswordHidden.value = !_isPasswordHidden.value;
                },
              ),
            ),
          );
        }
    );
  }

  Widget _buttonSignin(BuildContext context) {
    return ReactiveButton(
      title: 'Đăng nhập',
      activeColor: AppColors.primary,
      onPressed: () async {
        if (_emailController.text.isEmpty) {
          DisplayMessage.errorMessage('Vui lòng nhập email của bạn', context);
          throw 'Email không được để trống';
        }

        if (_passwordController.text.isEmpty) {
          DisplayMessage.errorMessage('Vui lòng nhập mật khẩu của bạn', context);
          throw 'Mật khẩu không được để trống';
        }

        final result = await sl<SigninUseCase>().call(
          params: SigninReqParams(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );

        return result;
      },
      onSuccess: () {
        AppNavigator.pushReplacement(context, VerifyOtpPage(email: _emailController.text));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng nhập thành công! Vui lòng xác thực OTP.'),
            backgroundColor: Colors.green,
          ),
        );
      },
      onFailure: (error) {
        DisplayMessage.errorMessage(error.toString(), context);
      },
    );
  }
}


