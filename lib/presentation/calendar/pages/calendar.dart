import 'package:flutter/material.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';

import '../../../common/widgets/tab_bar/tab_bar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tất cả lịch hẹn'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: AppColors.textBlack,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: const SafeArea(
        minimum: EdgeInsets.all(16),
        child: TabBarBasic(
          tabTitle1: 'Hôm nay',
          tabTitle2: 'Sắp tới',
          tabTitle3: 'Đã qua',),
      ),
    );
  }
}
