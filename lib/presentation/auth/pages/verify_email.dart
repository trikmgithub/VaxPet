import 'package:flutter/material.dart';
import 'package:vaxpet/common/helper/message/display_message.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/common/widgets/reactive_button/reactive_button.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:vaxpet/data/auth/models/verify_email_req_params.dart';
import 'package:vaxpet/domain/auth/usecases/verify_email.dart';
import 'package:vaxpet/service_locator.dart';

import '../../../common/widgets/app_bar/app_bar.dart';
import '../../main/pages/main.dart';

class VerifyEmailPage extends StatelessWidget {
  final String email;

  // Tạo 6 controllers cho 6 ô input OTP (static để tránh tạo lại khi widget rebuild)
  static final List<TextEditingController> _controllers = List.generate(
      6, (index) => TextEditingController());

  // Tạo 6 focus nodes cho 6 ô input OTP (static để tránh tạo lại khi widget rebuild)
  static final List<FocusNode> _focusNodes = List.generate(
      6, (index) => FocusNode());

  const VerifyEmailPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: false,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _title(),
            const SizedBox(height: 20),
            _emailDisplay(),
            const SizedBox(height: 10),
            _otpFieldsRow(context),
            const SizedBox(height: 30),
            _verifyButton(context),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: const Text(
        'Xác thực OTP',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: AppColors.textBlack,
        ),
      ),
    );
  }

  Widget _emailDisplay() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Text(
        'Mã xác thực đã được gửi đến: $email',
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textGray,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _otpFieldsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        6,
            (index) => SizedBox(
          width: 50,
          height: 50,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            style: const TextStyle(fontSize: 16),
            onChanged: (value) {
              if (value.length == 1) {
                // Khi nhập xong 1 số, tự động chuyển đến ô tiếp theo
                if (index < 5) {
                  _focusNodes[index].unfocus();
                  FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                }
              } else if (value.isEmpty && index > 0) {
                // Nếu người dùng xóa số, quay lại ô trước đó
                _focusNodes[index].unfocus();
                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              }
            },
          ),
        ),
      ),
    );
  }

  // Lấy mã OTP từ 6 controllers
  String _getOtpCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  Widget _verifyButton(BuildContext context) {
    return ReactiveButton(
      title: 'Xác nhận',
      activeColor: AppColors.primary,
      onPressed: () async {
        // Lấy mã OTP từ 6 controllers
        final otpCode = _getOtpCode();

        // Kiểm tra độ dài mã OTP
        if (otpCode.length != 6) {
          DisplayMessage.errorMessage('Vui lòng nhập đủ 6 số OTP', context);
          throw 'OTP không hợp lệ';
        }

        try {
          // Gọi API xác thực email
          final result = await sl<VerifyEmailUseCase>().call(
            params: VerifyEmailReqParams(
              email: email,
              otp: otpCode,
            ),
          );

          // Trả về kết quả để ReactiveButton xử lý
          return result;
        } catch (e) {
          throw 'Lỗi xác thực: ${e.toString()}';
        }
      },
      onSuccess: () {
        // Reset giá trị các ô input sau khi xác thực thành công
        for (var controller in _controllers) {
          controller.clear();
        }

        AppNavigator.pushAndRemove(context, MainPage());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xác thực thành công!'),
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
