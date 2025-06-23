import 'package:flutter/material.dart';
import '../../../core/configs/theme/app_colors.dart';

class BackButtonBasic extends StatelessWidget {
  const BackButtonBasic({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          color: AppColors.returnBackground,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 14,
            color: AppColors.returnIcon,
          ),
        ),
      ),
    );
  }
}
