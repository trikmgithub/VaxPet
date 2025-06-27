import 'package:flutter/material.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/presentation/auth/pages/verify_email.dart';
import '../../../common/helper/message/display_message.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../common/widgets/back_button/back_button.dart';
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
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final horizontalPadding = screenSize.width * 0.06; // 6% của width màn hình
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: BasicAppbar(
        hideBack: false,
        height: isSmallScreen ? 70 : 80,
        title: Text(
          'VaxPet',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 18 : 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenSize.height * 0.05),
                _buildWelcomeSection(screenSize),
                SizedBox(height: screenSize.height * 0.06),
                _buildFormCard(screenSize, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(Size screenSize) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary.withOpacity(0.1), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(
                Icons.pets,
                size: screenSize.width * 0.15,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Đăng ký tài khoản',
                style: TextStyle(
                  fontSize: screenSize.width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard(Size screenSize, BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.06),
        child: Column(
          children: [
            _buildEmailField(screenSize),
            SizedBox(height: screenSize.height * 0.025),
            _buildPasswordField(screenSize),
            SizedBox(height: screenSize.height * 0.04),
            _buildRegisterButton(context, screenSize),
            SizedBox(height: screenSize.height * 0.02),
            _buildLoginLink(context, screenSize),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(Size screenSize) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(fontSize: screenSize.width * 0.04),
        decoration: InputDecoration(
          hintText: 'Nhập email',
          hintStyle: TextStyle(
            color: AppColors.textGray,
            fontSize: screenSize.width * 0.04,
          ),
          prefixIcon: Icon(
            Icons.email_outlined,
            color: AppColors.primary,
            size: screenSize.width * 0.06,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.04,
            vertical: screenSize.height * 0.02,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(Size screenSize) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: _isPasswordHidden,
        builder: (context, isHidden, _) {
          return TextField(
            controller: _passwordController,
            obscureText: isHidden,
            style: TextStyle(fontSize: screenSize.width * 0.04),
            decoration: InputDecoration(
              hintText: 'Nhập mật khẩu',
              hintStyle: TextStyle(
                color: AppColors.textGray,
                fontSize: screenSize.width * 0.04,
              ),
              prefixIcon: Icon(
                Icons.lock_outlined,
                color: AppColors.primary,
                size: screenSize.width * 0.06,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isHidden ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.textGray,
                  size: screenSize.width * 0.06,
                ),
                onPressed: () {
                  _isPasswordHidden.value = !_isPasswordHidden.value;
                },
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.04,
                vertical: screenSize.height * 0.02,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context, Size screenSize) {
    return Container(
      width: double.infinity,
      height: screenSize.height * 0.065,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ReactiveButton(
        title: 'Đăng ký',
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

          final result = await sl<RegisterUseCase>().call(
            params: RegisterReqParams(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );

          return result;
        },
        onSuccess: () {
          AppNavigator.pushReplacement(
            context,
            VerifyEmailPage(email: _emailController.text)
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Đăng ký thành công! Vui lòng xác thực email của bạn.'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
        onFailure: (error) {
          DisplayMessage.errorMessage(error.toString(), context);
        },
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context, Size screenSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Đã có tài khoản? ',
          style: TextStyle(
            color: AppColors.textGray,
            fontSize: screenSize.width * 0.04,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            'Đăng nhập',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: screenSize.width * 0.04,
            ),
          ),
        ),
      ],
    );
  }
}