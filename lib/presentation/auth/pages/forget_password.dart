import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/helper/message/display_message.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../common/widgets/reactive_button/reactive_button.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/forgot_pass_otp_cubit.dart';
import '../bloc/forgot_pass_otp_state.dart';
import '../bloc/forgot_password_cubit.dart';
import '../bloc/forgot_password_state.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ForgotPassOtpCubit()),
        BlocProvider(create: (context) => ForgotPasswordCubit()),
      ],
      child: ForgetPasswordView(),
    );
  }
}

class ForgetPasswordView extends StatefulWidget {
  @override
  _ForgetPasswordViewState createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final ValueNotifier<bool> _isNewPasswordHidden = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isConfirmPasswordHidden = ValueNotifier<bool>(true);

  bool _isOtpSent = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final horizontalPadding = screenSize.width * 0.06;

    return MultiBlocListener(
      listeners: [
        BlocListener<ForgotPassOtpCubit, ForgotPassOtpState>(
          listener: (context, state) {
            if (state is ForgotPassOtpSuccess) {
              setState(() {
                _isOtpSent = true;
              });
              DisplayMessage.successMessage(state.message, context);

              // Reset trạng thái sau 60 giây
              Future.delayed(Duration(seconds: 60), () {
                if (mounted) {
                  setState(() {
                    _isOtpSent = false;
                  });
                }
              });
            } else if (state is ForgotPassOtpFailure) {
              DisplayMessage.errorMessage(state.error, context);
            }
          },
        ),
        BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              DisplayMessage.successMessage(state.message, context);
              Navigator.pop(context);
            } else if (state is ForgotPasswordFailure) {
              DisplayMessage.errorMessage(state.error, context);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: BasicAppbar(
          hideBack: false,
          height: isSmallScreen ? 70 : 80,
          title: Text(
            'Quên mật khẩu',
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
                  _buildHeaderSection(screenSize),
                  _buildFormCard(screenSize, context),
                  SizedBox(height: screenSize.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(Size screenSize) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(
                Icons.lock_reset_outlined,
                size: screenSize.width * 0.15,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Khôi phục mật khẩu',
                style: TextStyle(
                  fontSize: screenSize.width * 0.07,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Nhập email để nhận mã OTP và đặt lại mật khẩu',
                style: TextStyle(
                  fontSize: screenSize.width * 0.04,
                  color: AppColors.textGray,
                ),
                textAlign: TextAlign.center,
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
      shadowColor: Colors.black.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.06),
        child: Column(
          children: [
            _buildEmailField(screenSize),
            SizedBox(height: screenSize.height * 0.025),
            _buildOtpSection(screenSize, context),
            SizedBox(height: screenSize.height * 0.025),
            _buildNewPasswordField(screenSize),
            SizedBox(height: screenSize.height * 0.025),
            _buildConfirmPasswordField(screenSize),
            SizedBox(height: screenSize.height * 0.04),
            _buildSubmitButton(context, screenSize),
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
            color: Colors.grey.withValues(alpha: 0.1),
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
          hintText: 'Nhập email của bạn',
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

  Widget _buildOtpSection(Size screenSize, BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: screenSize.width * 0.04),
            decoration: InputDecoration(
              hintText: 'Nhập mã OTP',
              hintStyle: TextStyle(
                color: AppColors.textGray,
                fontSize: screenSize.width * 0.04,
              ),
              prefixIcon: Icon(
                Icons.security_outlined,
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
        ),
        SizedBox(height: screenSize.height * 0.015),
        BlocBuilder<ForgotPassOtpCubit, ForgotPassOtpState>(
          builder: (context, state) {
            final isLoading = state is ForgotPassOtpLoading;
            return Container(
              width: double.infinity,
              height: screenSize.height * 0.055,
              child: ElevatedButton(
                onPressed: (_isOtpSent || isLoading) ? null : () => _handleGetOtp(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_isOtpSent || isLoading) ? Colors.grey : AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _isOtpSent ? 'OTP đã gửi' : 'Lấy OTP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenSize.width * 0.04,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNewPasswordField(Size screenSize) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: _isNewPasswordHidden,
        builder: (context, isHidden, _) {
          return TextField(
            controller: _newPasswordController,
            obscureText: isHidden,
            style: TextStyle(fontSize: screenSize.width * 0.04),
            decoration: InputDecoration(
              hintText: 'Nhập mật khẩu mới',
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
                  _isNewPasswordHidden.value = !_isNewPasswordHidden.value;
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

  Widget _buildConfirmPasswordField(Size screenSize) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: _isConfirmPasswordHidden,
        builder: (context, isHidden, _) {
          return TextField(
            controller: _confirmPasswordController,
            obscureText: isHidden,
            style: TextStyle(fontSize: screenSize.width * 0.04),
            decoration: InputDecoration(
              hintText: 'Xác nhận mật khẩu mới',
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
                  _isConfirmPasswordHidden.value = !_isConfirmPasswordHidden.value;
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

  Widget _buildSubmitButton(BuildContext context, Size screenSize) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: screenSize.height * 0.065,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ReactiveButton(
            title: 'Đổi mật khẩu',
            activeColor: AppColors.primary,
            onPressed: () async {
              return await _handleSubmit(context);
            },
            onSuccess: () {
              // Success will be handled by BlocListener
            },
            onFailure: (error) {
              // Error will be handled by BlocListener
            },
          ),
        );
      },
    );
  }

  void _handleGetOtp(BuildContext context) {
    if (_emailController.text.isEmpty) {
      DisplayMessage.errorMessage('Vui lòng nhập email', context);
      return;
    }

    // Kiểm tra định dạng email
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text)) {
      DisplayMessage.errorMessage('Email không hợp lệ', context);
      return;
    }

    // Gọi cubit để gửi OTP
    context.read<ForgotPassOtpCubit>().sendOtp(_emailController.text);
  }

  Future<bool> _handleSubmit(BuildContext context) async {
    // Kiểm tra email
    if (_emailController.text.isEmpty) {
      throw 'Vui lòng nhập email';
    }

    // Kiểm tra OTP
    if (_otpController.text.isEmpty) {
      throw 'Vui lòng nhập mã OTP';
    }

    // Kiểm tra mật khẩu mới
    if (_newPasswordController.text.isEmpty) {
      throw 'Vui lòng nhập mật khẩu mới';
    }

    if (_newPasswordController.text.length < 6) {
      throw 'Mật khẩu phải có ít nhất 6 ký tự';
    }

    // Kiểm tra xác nhận mật khẩu
    if (_confirmPasswordController.text.isEmpty) {
      throw 'Vui lòng xác nhận mật khẩu';
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      throw 'Mật khẩu xác nhận không khớp';
    }

    // Gọi cubit để reset password
    context.read<ForgotPasswordCubit>().resetPassword(
      email: _emailController.text,
      otp: _otpController.text,
      newPassword: _newPasswordController.text,
    );

    return true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _isNewPasswordHidden.dispose();
    _isConfirmPasswordHidden.dispose();
    super.dispose();
  }
}
