import 'package:flutter/material.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';

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
      body: const SafeArea(
        minimum: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'Nội dung trang Tài khoản',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
