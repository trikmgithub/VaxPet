import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:vaxpet/common/helper/message/display_message.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/common/widgets/reactive_button/reactive_button.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:vaxpet/data/auth/models/verify_email_req_params.dart';
import 'package:vaxpet/domain/auth/usecases/verify_email.dart';
import 'package:vaxpet/presentation/main_bottom_navigator/pages/main_bottom_navigator.dart';
import 'package:vaxpet/service_locator.dart';
import '../../../common/widgets/app_bar/app_bar.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;

  const VerifyEmailPage({super.key, required this.email});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> with TickerProviderStateMixin {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  Timer? _timer;
  int _remainingSeconds = 300; // 5 phút = 300 giây

  @override
  void initState() {
    super.initState();

    // Initialize controllers and focus nodes
    _controllers = List.generate(6, (index) => TextEditingController());
    _focusNodes = List.generate(6, (index) => FocusNode());

    // Initialize animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start animation and timer
    _animationController.forward();
    _startTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = 300; // 5 phút = 300 giây
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
          // Khi hết thời gian, tự động quay về trang trước
          Navigator.of(context).pop();
          DisplayMessage.errorMessage('Mã OTP đã hết hạn. Vui lòng thử lại.', context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          'VaxPet',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
        backgroundColor: AppColors.primary,
        hideBack: false,
        elevation: 2,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        _buildHeader(),
                        const SizedBox(height: 32),
                        _buildEmailDisplay(),
                        const SizedBox(height: 40),
                        _buildOtpFields(),
                        const SizedBox(height: 32),
                        _buildTimer(),
                        const SizedBox(height: 24),
                        _buildVerifyButton(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.mail_outline,
            size: 40,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Xác thực Email',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Vui lòng nhập mã xác thực được gửi đến email của bạn',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textGray,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.email,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              widget.email,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpFields() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(6, (index) => _buildOtpField(index)),
      ),
    );
  }

  Widget _buildOtpField(int index) {
    final bool isActive = _focusNodes[index].hasFocus;
    final bool isFilled = _controllers[index].text.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 48,
      height: 58,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withValues(alpha: 0.1)
            : isFilled
                ? AppColors.primary.withValues(alpha: 0.05)
                : Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: isFilled
                ? AppColors.primary
                : Colors.grey.shade400,
            height: 1.2,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            hintText: isFilled ? '' : '0',
            hintStyle: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          onChanged: (value) => _onOtpChanged(value, index),
          onTap: () => setState(() {}),
        ),
      ),
    );
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1) {
      if (index < 5) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
    setState(() {});
  }

  Widget _buildTimer() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    final timeText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _remainingSeconds <= 30 ? Colors.red.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _remainingSeconds <= 30 ? Colors.red.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 18,
            color: _remainingSeconds <= 30 ? Colors.red : Colors.orange,
          ),
          const SizedBox(width: 8),
          Text(
            'Thời gian còn lại: $timeText',
            style: TextStyle(
              fontSize: 14,
              color: _remainingSeconds <= 30 ? Colors.red : Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _clearOtpFields() {
    for (var controller in _controllers) {
      controller.clear();
    }
    FocusScope.of(context).requestFocus(_focusNodes[0]);
    setState(() {});
  }

  String _getOtpCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ReactiveButton(
        title: 'Xác nhận',
        activeColor: AppColors.primary,
        onPressed: _verifyEmail,
        onSuccess: _onVerifySuccess,
        onFailure: _onVerifyFailure,
      ),
    );
  }

  Future<dynamic> _verifyEmail() async {
    final otpCode = _getOtpCode();

    if (otpCode.length != 6) {
      throw 'Vui lòng nhập đủ 6 số OTP';
    }

    setState(() {});

    try {
      final result = await sl<VerifyEmailUseCase>().call(
        params: VerifyEmailReqParams(
          email: widget.email,
          otp: otpCode,
        ),
      );
      return result;
    } catch (e) {
      throw 'Mã OTP không chính xác. Vui lòng thử lại.';
    } finally {}
  }

  void _onVerifySuccess() {
    _clearOtpFields();
    _timer?.cancel();

    AppNavigator.pushAndRemove(context, MainBottomNavigatorPage());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Xác thực thành công!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _onVerifyFailure(error) {
    // Shake animation for wrong OTP
    _animationController.reset();
    _animationController.forward();

    DisplayMessage.errorMessage(error.toString(), context);
  }
}
