import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/helper/message/display_message.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
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

  // Password validation states
  bool get hasMinLength => _newPasswordController.text.length >= 8;
  bool get hasUpperCase => _newPasswordController.text.contains(RegExp(r'[A-Z]'));
  bool get hasNumber => _newPasswordController.text.contains(RegExp(r'[0-9]'));

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          child: ValueListenableBuilder<bool>(
            valueListenable: _isNewPasswordHidden,
            builder: (context, isHidden, _) {
              return TextField(
                controller: _newPasswordController,
                obscureText: isHidden,
                style: TextStyle(fontSize: screenSize.width * 0.04),
                onChanged: (value) {
                  setState(() {}); // Trigger rebuild to update password requirements
                },
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
        ),
        SizedBox(height: screenSize.width * 0.02),
        _buildRequirement(
          'Ít nhất 8 ký tự',
          hasMinLength,
          screenSize,
        ),
        _buildRequirement(
          'Ít nhất một chữ cái viết hoa',
          hasUpperCase,
          screenSize,
        ),
        _buildRequirement(
          'Ít nhất một chữ số',
          hasNumber,
          screenSize,
        ),
      ],
    );
  }

  Widget _buildRequirement(String text, bool isValid, Size screenSize) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isValid ? Colors.green : AppColors.textGray,
            size: screenSize.width * 0.04,
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isValid ? Colors.green : AppColors.textGray,
              fontSize: screenSize.width * 0.035,
            ),
          ),
        ],
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
        final isLoading = state is ForgotPasswordLoading;
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
          child: ElevatedButton(
            onPressed: isLoading ? null : () => _handleSubmit(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
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
                    'Đổi mật khẩu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenSize.width * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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

  void _handleSubmit(BuildContext context) {
    try {
      // Kiểm tra email
      if (_emailController.text.isEmpty) {
        DisplayMessage.errorMessage('Vui lòng nhập email', context);
        return;
      }

      // Kiểm tra OTP
      if (_otpController.text.isEmpty) {
        DisplayMessage.errorMessage('Vui lòng nhập mã OTP', context);
        return;
      }

      // Kiểm tra mật khẩu mới
      if (_newPasswordController.text.isEmpty) {
        DisplayMessage.errorMessage('Vui lòng nhập mật khẩu mới', context);
        return;
      }

      if (_newPasswordController.text.length < 8) {
        DisplayMessage.errorMessage('Mật khẩu phải có ít nhất 8 ký tự', context);
        return;
      }

      // Kiểm tra xác nhận mật khẩu
      if (_confirmPasswordController.text.isEmpty) {
        DisplayMessage.errorMessage('Vui lòng xác nhận mật khẩu', context);
        return;
      }

      if (_newPasswordController.text != _confirmPasswordController.text) {
        DisplayMessage.errorMessage('Mật khẩu xác nhận không khớp', context);
        return;
      }

      // Gọi cubit để reset password
      context.read<ForgotPasswordCubit>().resetPassword(
        email: _emailController.text,
        otp: _otpController.text,
        newPassword: _newPasswordController.text,
      );
    } catch (e) {
      DisplayMessage.errorMessage('Có lỗi xảy ra: ${e.toString()}', context);
    }
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
