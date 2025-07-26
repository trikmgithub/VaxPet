import 'package:flutter/material.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';

import '../../../common/widgets/app_bar/app_bar.dart';

class PointHistoryPage extends StatelessWidget {
  const PointHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          'Lịch sử điểm',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
        backgroundColor: AppColors.primary,
        hideBack: false,
        elevation: 2,
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
