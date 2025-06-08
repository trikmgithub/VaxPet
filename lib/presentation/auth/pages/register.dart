import 'package:flutter/material.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/common/widgets/appbar/app_bar.dart';
import 'package:vaxpet/presentation/auth/pages/verify_email.dart';

import '../../../common/helper/message/display_message.dart';
import '../../../common/widgets/reactive_button/reactive_button.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../data/auth/models/register_req_params.dart';
import '../../../domain/auth/usecases/register.dart';
import '../../../service_locator.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

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
        minimum: const EdgeInsets.only(
          top: 0,
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
            _buttonRegister(context),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Container(
      alignment: Alignment.center,
      child: const Text(
        'Đăng ký',
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

  Widget _buttonRegister(BuildContext context) {
    return ReactiveButton(
      title: 'Đăng ký',
      activeColor: AppColors.primary,
      onPressed: () async {
        // Kiểm tra thông tin nhập vào
        if (_emailController.text.isEmpty) {
          DisplayMessage.errorMessage('Vui lòng nhập email của bạn', context);
          throw 'Email không được để trống';
        }

        if (_passwordController.text.isEmpty) {
          DisplayMessage.errorMessage('Vui lòng nhập mật khẩu của bạn', context);
          throw 'Mật khẩu không được để trống';
        }

        // Gọi API đăng ký và trả về kết quả để ReactiveButton xử lý
        final result = await sl<RegisterUseCase>().call(
          params: RegisterReqParams(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );

        // Trả về kết quả cho ReactiveButton xử lý
        return result;
      },
      onSuccess: () {
        // Chuyển đến trang VerifyEmail và truyền email
        AppNavigator.pushReplacement(
          context,
          VerifyEmailPage(email: _emailController.text)
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công! Vui lòng xác thực email của bạn.'),
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
