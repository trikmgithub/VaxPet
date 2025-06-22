import 'package:flutter/material.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thay đổi mật khẩu'),
        centerTitle: true,
        backgroundColor: AppColors.primary, // Màu nền cho AppBar
        titleTextStyle: TextStyle(
          color: Colors.white, // Màu chữ trắng để tương phản với nền
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white), // Màu icon trắng
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            'Chức năng đang được phát triển',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
